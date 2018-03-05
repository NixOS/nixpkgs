# This expression takes a file like `hackage-packages.nix` and constructs
# a full package set out of that.

{ # package-set used for build tools (all of nixpkgs)
  buildPackages

, # A haskell package set for Setup.hs, compiler plugins, and similar
  # build-time uses.
  buildHaskellPackages

, # package-set used for non-haskell dependencies (all of nixpkgs)
  pkgs

, # stdenv to use for building haskell packages
  stdenv

, haskellLib

, # hashes for downloading Hackage packages
  all-cabal-hashes

, # compiler to use
  ghc

, # A function that takes `{ pkgs, stdenv, callPackage }` as the first arg and
  # `self` as second, and returns a set of haskell packages
  package-set

, # The final, fully overriden package set usable with the nixpkgs fixpoint
  # overriding functionality
  extensible-self
}:

# return value: a function from self to the package set
self:

let
  inherit (stdenv) buildPlatform hostPlatform;

  inherit (stdenv.lib) fix' extends makeOverridable;
  inherit (haskellLib) overrideCabal;

  mkDerivationImpl = pkgs.callPackage ./generic-builder.nix {
    inherit stdenv;
    nodejs = buildPackages.nodejs-slim;
    inherit buildHaskellPackages;
    inherit (self) ghc;
    inherit (buildHaskellPackages) jailbreak-cabal;
    hscolour = overrideCabal buildHaskellPackages.hscolour (drv: {
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

  # manualArgs are the arguments that were explictly passed to `callPackage`, like:
  #
  # callPackage foo { bar = null; };
  #
  # here `bar` is a manual argument.
  callPackageWithScope = scope: fn: manualArgs:
    let
      # this code is copied from callPackage in lib/customisation.nix
      #
      # we cannot use `callPackage` here because we want to call `makeOverridable`
      # on `drvScope` (we cannot add `overrideScope` after calling `callPackage` because then it is
      # lost on `.override`) but determine the auto-args based on `drv` (the problem here
      # is that nix has no way to "passthrough" args while preserving the reflection
      # info that callPackage uses to determine the arguments).
      drv = if stdenv.lib.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (stdenv.lib.functionArgs drv) scope;

      # this wraps the `drv` function to add a `overrideScope` function to the result.
      drvScope = allArgs: drv allArgs // {
        overrideScope = f:
          let newScope = mkScope (fix' (extends f scope.__unfix__));
          # note that we have to be careful here: `allArgs` includes the auto-arguments that
          # weren't manually specified. If we would just pass `allArgs` to the recursive call here,
          # then we wouldn't look up any packages in the scope in the next interation, because it
          # appears as if all arguments were already manually passed, so the scope change would do
          # nothing.
          in callPackageWithScope newScope drv manualArgs;
      };
    in stdenv.lib.makeOverridable drvScope (auto // manualArgs);

  mkScope = scope: pkgs // pkgs.xorg // pkgs.gnome2 // { inherit stdenv; } // scope;
  defaultScope = mkScope self;
  callPackage = drv: args: callPackageWithScope defaultScope drv args;

  withPackages = packages: buildPackages.callPackage ./with-packages-wrapper.nix {
    inherit (self) llvmPackages;
    inherit ghc;
    inherit packages;
  };

  haskellSrc2nix = { name, src, sha256 ? null }:
    let
      sha256Arg = if isNull sha256 then "--sha256=" else ''--sha256="${sha256}"'';
    in pkgs.buildPackages.stdenv.mkDerivation {
      name = "cabal2nix-${name}";
      nativeBuildInputs = [ pkgs.buildPackages.cabal2nix ];
      preferLocalBuild = true;
      phases = ["installPhase"];
      LANG = "en_US.UTF-8";
      LOCALE_ARCHIVE = pkgs.lib.optionalString buildPlatform.isLinux "${buildPackages.glibcLocales}/lib/locale/locale-archive";
      installPhase = ''
        export HOME="$TMP"
        mkdir -p "$out"
        cabal2nix --compiler=${ghc.haskellCompilerName} --system=${stdenv.system} ${sha256Arg} "${src}" > "$out/default.nix"
      '';
  };

  all-cabal-hashes-component = name: version: pkgs.runCommand "all-cabal-hashes-component-${name}-${version}" {} ''
    tar --wildcards -xzvf ${all-cabal-hashes} \*/${name}/${version}/${name}.{json,cabal}
    mkdir -p $out
    mv */${name}/${version}/${name}.{json,cabal} $out
  '';

  hackage2nix = name: version: let component = all-cabal-hashes-component name version; in self.haskellSrc2nix {
    name   = "${name}-${version}";
    sha256 = ''$(sed -e 's/.*"SHA256":"//' -e 's/".*$//' "${component}/${name}.json")'';
    src    = "${component}/${name}.cabal";
  };

in package-set { inherit pkgs stdenv callPackage; } self // {

    inherit mkDerivation callPackage haskellSrc2nix hackage2nix;

    inherit (haskellLib) packageSourceOverrides;

    callHackage = name: version: self.callPackage (self.hackage2nix name version);

    # Creates a Haskell package from a source package by calling cabal2nix on the source.
    callCabal2nix = name: src: args: let
      filter = path: type:
                 pkgs.lib.hasSuffix "${name}.cabal" path ||
                 baseNameOf path == "package.yaml";
      expr = haskellSrc2nix {
        inherit name;
        src = if pkgs.lib.canCleanSource src
                then pkgs.lib.cleanSourceWith { inherit src filter; }
              else src;
      };
    in overrideCabal (self.callPackage expr args) (orig: {
         inherit src;
         preConfigure =
           "# Generated from ${expr}\n${orig.preConfigure or ""}";
       });

    # : { root : Path
    #   , source-overrides : Defaulted (Either Path VersionNumber)
    #   , overrides : Defaulted (HaskellPackageOverrideSet)
    #   , modifier : Defaulted
    #   } -> NixShellAwareDerivation
    # Given a path to a haskell package directory whose cabal file is
    # named the same as the directory name, an optional set of
    # source overrides as appropriate for the 'packageSourceOverrides'
    # function, an optional set of arbitrary overrides, and an optional
    # haskell package modifier,  return a derivation appropriate
    # for nix-build or nix-shell to build that package.
    developPackage = { root, source-overrides ? {}, overrides ? self: super: {}, modifier ? drv: drv }:
      let name = builtins.baseNameOf root;
          drv =
            (extensible-self.extend (pkgs.lib.composeExtensions (self.packageSourceOverrides source-overrides) overrides)).callCabal2nix name root {};
      in if pkgs.lib.inNixShell then (modifier drv).env else modifier drv;

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
