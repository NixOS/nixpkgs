# This expression takes a file like `hackage-packages.nix` and constructs
# a full package set out of that.

# required dependencies:
{ pkgs, stdenv, all-cabal-hashes }:

# arguments:
#  * ghc package to use
#  * package-set: a function that takes { pkgs, stdenv, callPackage } as first arg and `self` as second
#  * extensible-self: the final, fully overriden package set usable with the nixpkgs fixpoint overriding functionality
{ ghc, package-set, extensible-self }:

# return value: a function from self to the package set
self: let

  inherit (stdenv.lib) fix' extends makeOverridable callPackageWith;
  inherit (import ./lib.nix { inherit pkgs; }) overrideCabal;

  mkDerivationImpl = pkgs.callPackage ./generic-builder.nix {
    inherit stdenv;
    inherit (pkgs) fetchurl pkgconfig glibcLocales coreutils gnugrep gnused;
    nodejs = pkgs.nodejs-slim;
    jailbreak-cabal = if (self.ghc.cross or null) != null
      then self.ghc.bootPkgs.jailbreak-cabal
      else self.jailbreak-cabal;
    inherit (self) ghc;
    hscolour = overrideCabal self.hscolour (drv: {
      isLibrary = false;
      doHaddock = false;
      hyperlinkSource = false;      # Avoid depending on hscolour for this build.
      postFixup = "rm -rf $out/lib $out/share $out/nix-support";
    });
    cpphs = overrideCabal (self.cpphs.overrideScope (self: super: {
      mkDerivation = drv: super.mkDerivation (drv // {
        enableSharedExecutables = false;
        enableSharedLibraries = false;
        doHaddock = false;
        useCpphs = false;
      });
    })) (drv: {
        isLibrary = false;
        postFixup = "rm -rf $out/lib $out/share $out/nix-support";
    });
  };

  mkDerivation = makeOverridable mkDerivationImpl;

  mkScope = scope: pkgs // pkgs.xorg // pkgs.gnome2 // scope;
  defaultScope = mkScope self;
  callPackage = drv: args: callPackageWith defaultScope drv args;

  withPackages = packages: callPackage ./with-packages-wrapper.nix {
    inherit (self) llvmPackages;
    haskellPackages = self;
    inherit packages;
  };

  haskellSrc2nix = { name, src, sha256 ? null }:
    let
      sha256Arg = if isNull sha256 then "--sha256=" else ''--sha256="${sha256}"'';
    in pkgs.stdenv.mkDerivation {
      name = "cabal2nix-${name}";
      buildInputs = [ pkgs.haskellPackages.cabal2nix ];
      preferLocalBuild = true;
      phases = ["installPhase"];
      LANG = "en_US.UTF-8";
      LOCALE_ARCHIVE = pkgs.lib.optionalString pkgs.stdenv.isLinux "${pkgs.glibcLocales}/lib/locale/locale-archive";
      installPhase = ''
        export HOME="$TMP"
        mkdir -p "$out"
        cabal2nix --compiler=${self.ghc.name} --system=${stdenv.system} ${sha256Arg} "${src}" > "$out/default.nix"
      '';
  };

  hackage2nix = name: version: self.haskellSrc2nix {
    name   = "${name}-${version}";
    sha256 = ''$(sed -e 's/.*"SHA256":"//' -e 's/".*$//' "${all-cabal-hashes}/${name}/${version}/${name}.json")'';
    src    = "${all-cabal-hashes}/${name}/${version}/${name}.cabal";
  };

in package-set { inherit pkgs stdenv callPackage; } self // {

    inherit mkDerivation callPackage haskellSrc2nix hackage2nix;

    callHackage = name: version: self.callPackage (self.hackage2nix name version);

    # Creates a Haskell package from a source package by calling cabal2nix on the source.
    callCabal2nix = name: src: self.callPackage (self.haskellSrc2nix { inherit src name; });

    # : Map Name (Either Path VersionNumber) -> HaskellPackageOverrideSet
    # Given a set whose values are either paths or version strings, produces
    # a package override set (i.e. (self: super: { etc. })) that sets
    # the packages named in the input set to the corresponding versions
    packageSourceOverrides =
      overrides: self: super: pkgs.lib.mapAttrs (name: src:
        let isPath = x: builtins.substring 0 1 (toString x) == "/";
            generateExprs = if isPath src
                               then self.callCabal2nix
                               else self.callHackage;
        in generateExprs name src {}) overrides;

    # : { root : Path
    #   , source-overrides : Defaulted (Either Path VersionNumber)
    #   , overrides : Defaulted (HaskellPackageOverrideSet)
    #   } -> NixShellAwareDerivation
    # Given a path to a haskell package directory whose cabal file is
    # named the same as the directory name, an optional set of
    # source overrides as appropriate for the 'packageSourceOverrides'
    # function, and an optional set of arbitrary overrides,
    # return a derivation appropriate for nix-build or nix-shell
    # to build that package.
    developPackage = { root, source-overrides ? {}, overrides ? self: super: {} }:
      let name = builtins.baseNameOf root;
          drv =
            (extensible-self.extend (pkgs.lib.composeExtensions (self.packageSourceOverrides source-overrides) overrides)).callCabal2nix name root {};
      in if pkgs.lib.inNixShell then drv.env else drv;

    ghcWithPackages = selectFrom: withPackages (selectFrom self);

    ghcWithHoogle = selectFrom:
      let
        packages = selectFrom self;
        hoogle = callPackage ./hoogle.nix {
          inherit packages;
        };
      in withPackages (packages ++ [ hoogle ]);

    ghc = ghc // {
      withPackages = self.ghcWithPackages;
      withHoogle = self.ghcWithHoogle;
    };

  }
