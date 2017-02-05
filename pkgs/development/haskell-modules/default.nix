{ pkgs, stdenv, ghc, all-cabal-hashes
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
}:

let

  inherit (stdenv.lib) fix' extends;

  haskellPackages = self:
    let

      mkDerivation = pkgs.callPackage ./generic-builder.nix {
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

      overrideCabal = drv: f: drv.override (args: args // {
        mkDerivation = drv: args.mkDerivation (drv // f drv);
      });

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

    in
      import ./hackage-packages.nix { inherit pkgs stdenv callPackage; } self // {

        inherit mkDerivation callPackage;

        # Creates a Haskell package from a source package by calling cabal2nix
        # on the source.
        haskellSrc2nix = { src, name ? "src", sha256 ? null }:
          pkgs.stdenv.mkDerivation {
            name = "cabal2nix-${name}";
            buildInputs = [ pkgs.cabal2nix ];
            phases = ["installPhase"];
            LANG = "en_US.UTF-8";
            LOCALE_ARCHIVE = pkgs.lib.optionalString pkgs.stdenv.isLinux
              "${pkgs.glibcLocales}/lib/locale/locale-archive";
            installPhase = ''
              export HOME="$TMP"
              mkdir -p "$out"
              cabal2nix --compiler=${self.ghc.name} --system=${stdenv.system} \
                ${pkgs.lib.optionalString (!(isNull sha256))
                    "--sha256=${sha256}"} \
                "${src}" > "$out/default.nix"
            '';
            preferLocalBuild = true;
        };

        # Creates a Haskell package from a name and version, as seen in Hackage.
        # Note that this only works for the name and version combinations
        # present in `all-cabal-hashes`.
        hackage2nix = name: version: self.haskellSrc2nix {
          name   = "${name}-${version}";
          sha256 = ''$(sed -e 's/.*"SHA256":"//' -e 's/".*$//' \
                       "${all-cabal-hashes}/${name}/${version}/${name}.json")'';
          src    = "${all-cabal-hashes}/${name}/${version}/${name}.cabal";
        };

        # Call a Haskell package created from its Hackage definition. See
        # `hackage2nix'.
        callHackage = name: version:
          self.callPackage (self.hackage2nix name version);

        # Call a Haskell package created from its source. See `haskellSrc2nix'.
        callCabal2nix = name: src:
          self.callPackage (self.haskellSrc2nix { inherit src name; });

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

in

  fix'
    (extends overrides
      (extends packageSetConfig
        (extends compilerConfig
          (extends commonConfiguration haskellPackages))))
