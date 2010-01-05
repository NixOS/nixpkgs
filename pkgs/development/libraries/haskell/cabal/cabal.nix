# generic builder for Cabal packages

attrs :
{
  mkDerivation =
    transform :
    let dtransform =
          self : {

            # pname should be defined by the client to be the package basename
            # version should be defined by the client to be the package version

            # fname is the internal full name of the package
            fname = "${self.pname}-${self.version}";

            # name is the external full name of the package; usually we prefix
            # all packages with haskell- to avoid name clashes for libraries;
            # if that is not desired (for applications), name can be set to
            # fname.
            name = "haskell-${self.pname}-ghc${attrs.ghc.ghc.version}-${self.version}";

            # the default download location for Cabal packages is Hackage,
            # you still have to specify the checksum
            src = attrs.fetchurl {
              url = "http://hackage.haskell.org/packages/archive/${self.pname}/${self.version}/${self.fname}.tar.gz";
              inherit (self) sha256;
            };

            # default buildInputs are just ghc, if more buildInputs are required
            # buildInputs can be extended by the client by using extraBuildInputs,
            # but often propagatedBuildInputs is preferable anyway
            buildInputs = [attrs.ghc] ++ self.extraBuildInputs;
            extraBuildInputs = [];

            # we make sure that propagatedBuildInputs is defined, so that we don't
            # have to check for its existence
            propagatedBuildInputs = [];

            # library directories that have to be added to the Cabal files
            extraLibDirs = [];

            # compiles Setup and configures
            configurePhase = ''
              eval "$preConfigure"

              for i in Setup.hs Setup.lhs; do
                test -f $i && ghc --make $i
              done

              for p in $propagatedBuildInputs; do
                for d in lib{,64}; do
                  if [ -e "$p/$d" ]; then
                    extraLibDirs="$extraLibDirs --extra-lib-dir=$p/$d"
                  fi
                done
              done

              ./Setup configure --verbose --prefix="$out" $extraLibDirs $configureFlags

              eval "$postConfigure"
            '';

            # builds via Cabal
            buildPhase = ''
              eval "$preBuild"

              ./Setup build

              export GHC_PACKAGE_PATH=$(ghc-packages)
              ./Setup haddock

              eval "$postBuild"
            '';

            # installs via Cabal; creates a registration file for nix-support
            # so that the package can be used in other Haskell-builds; also
            # adds all propagated build inputs to the user environment packages
            installPhase = ''
              eval "$preInstall"

              ./Setup copy

              ensureDir $out/bin # necessary to get it added to PATH

              local confDir=$out/lib/ghc-pkgs/ghc-${attrs.ghc.ghc.version}
              local installedPkgConf=$confDir/${self.fname}.installedconf
              local pkgConf=$confDir/${self.fname}.conf
              ensureDir $confDir
              ./Setup register --gen-pkg-config=$pkgConf
              if test -f $pkgConf; then
                echo '[]' > $installedPkgConf
                GHC_PACKAGE_PATH=$installedPkgConf ghc-pkg --global register $pkgConf --force
              fi

              ensureDir $out/nix-support
              ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages

              eval "$postInstall"
            '';
          };
    in  attrs.stdenv.mkDerivation ((rec { f = dtransform f // transform f; }).f);
}
