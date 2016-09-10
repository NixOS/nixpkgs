{ pkgs, stdenv, ghc
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
}:

let

  allCabalFiles = pkgs.fetchFromGitHub {
     owner = "commercialhaskell";
     repo = "all-cabal-hashes";
     rev = "72f1318540eff69544eb8c14a16f630d0c5448b8";
     sha256 = "1czi1rajk2726mqrw3qp7a43h26acbjw54ll3ns063yzg9hg469m";
   };

  inherit (stdenv.lib) fix' extends;

  haskellPackages = self:
    let

      mkDerivation = pkgs.callPackage ./generic-builder.nix {
        inherit stdenv;
        inherit (pkgs) fetchurl pkgconfig glibcLocales coreutils gnugrep gnused;
        inherit (self) ghc jailbreak-cabal;
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

      mkScope = scope: pkgs // pkgs.xorg // pkgs.gnome // scope;
      defaultScope = mkScope self;
      callPackage = drv: args: callPackageWithScope defaultScope drv args;

      withPackages = packages: callPackage ./with-packages-wrapper.nix {
        inherit (self) llvmPackages;
        haskellPackages = self;
        inherit packages;
      };

      hackage2nix = name: version: pkgs.stdenv.mkDerivation {
        name = "cabal2nix-${name}-${version}";
        buildInputs = [ pkgs.cabal2nix ];
        phases = ["installPhase"];
        LANG = "en_US.UTF-8";
        LOCALE_ARCHIVE = pkgs.lib.optionalString pkgs.stdenv.isLinux "${pkgs.glibcLocales}/lib/locale/locale-archive";
        installPhase = ''
          export HOME="$TMP"
          mkdir $out
          hash=$(sed -e 's/.*"SHA256":"//' -e 's/".*$//' ${allCabalFiles}/${name}/${version}/${name}.json)
          cabal2nix --compiler=${self.ghc.name} --system=${stdenv.system} --sha256=$hash ${allCabalFiles}/${name}/${version}/${name}.cabal >$out/default.nix
        '';
      };

    in
      import ./hackage-packages.nix { inherit pkgs stdenv callPackage; } self // {

        inherit mkDerivation callPackage;

        callHackage = name: version: self.callPackage (hackage2nix name version);

        ghcWithPackages = selectFrom: withPackages (selectFrom self);

        ghcWithHoogle = selectFrom:
          let
            packages = selectFrom self;
            hoogle = callPackage ./hoogle.nix {
              inherit packages;
              hoogle = self.hoogle_4_2_43;
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
