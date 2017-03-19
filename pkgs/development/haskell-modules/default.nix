{ pkgs, stdenv, ghc, all-cabal-hashes
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
}:

let

  inherit (stdenv.lib) fix' extends makeOverridable makeExtensible;
  inherit (import ./lib.nix { inherit pkgs; }) overrideCabal;

  haskellPackages = self:
    let

      mkDerivationImpl = pkgs.callPackage ./generic-builder.nix {
        inherit stdenv;
        inherit (pkgs) fetchurl pkgconfig glibcLocales coreutils gnugrep gnused;
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

      callPackageWithScope = scope: drv: args: (stdenv.lib.callPackageWith scope drv args) // {
        overrideScope = f: callPackageWithScope (mkScope (fix' (extends f scope.__unfix__))) drv args;
      };

      mkScope = scope: pkgs // pkgs.xorg // pkgs.gnome2 // scope;
      defaultScope = mkScope self;
      callPackage = drv: args: callPackageWithScope defaultScope drv args;

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
          buildInputs = [ pkgs.cabal2nix ];
          phases = ["installPhase"];
          LANG = "en_US.UTF-8";
          LOCALE_ARCHIVE = pkgs.lib.optionalString pkgs.stdenv.isLinux "${pkgs.glibcLocales}/lib/locale/locale-archive";
          installPhase = ''
            export HOME="$TMP"
            mkdir -p "$out"
            cabal2nix --compiler=${self.ghc.name} --system=${stdenv.system} ${sha256Arg} "${src}" > "$out/default.nix"
          '';
      };

      hackage2nix = name: version: haskellSrc2nix {
        name   = "${name}-${version}";
        sha256 = ''$(sed -e 's/.*"SHA256":"//' -e 's/".*$//' "${all-cabal-hashes}/${name}/${version}/${name}.json")'';
        src    = "${all-cabal-hashes}/${name}/${version}/${name}.cabal";
      };

    in
      import ./hackage-packages.nix { inherit pkgs stdenv callPackage; } self // {

        inherit mkDerivation callPackage;

        callHackage = name: version: self.callPackage (hackage2nix name version);

        # Creates a Haskell package from a source package by calling cabal2nix on the source.
        callCabal2nix = name: src: args:
          let
            # Filter out files other than the cabal file. This ensures
            # that we don't create new derivations even when the cabal
            # file hasn't changed.
            justCabal = builtins.filterSource (path: type: pkgs.lib.hasSuffix ".cabal" path) src;
            drv = self.callPackage (haskellSrc2nix { inherit name; src = justCabal; }) args;
          in overrideCabal drv (drv': { inherit src; }); # Restore the desired src.

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

      };

  commonConfiguration = import ./configuration-common.nix { inherit pkgs; };
  nixConfiguration = import ./configuration-nix.nix { inherit pkgs; };

in

  makeExtensible
    (extends overrides
      (extends packageSetConfig
        (extends compilerConfig
          (extends commonConfiguration
            (extends nixConfiguration haskellPackages)))))
