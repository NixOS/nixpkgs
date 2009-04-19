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
            extraLibDirs = map (x : x + "/lib") self.propagatedBuildInputs;

            # file(s) that have to be patched with information about extra libraries;
            # can be redefined to the empty list by the client if this is not desired
            patchLibFiles = [ "${self.pname}.cabal" ];

            # patches files, compiles Setup, and configures
            configurePhase = ''
              eval "$preConfigure"

              for i in ${toString self.patchLibFiles}; do
                echo "patching $i"
                test -f $i && sed -i '/[eE]xtra-[lL]ibraries/ { s|^\( *\)[eE]xtra-[lL]ibraries.*|&\n\1extra-lib-dirs: ${toString self.extraLibDirs}| }' $i
              done
              for i in Setup.hs Setup.lhs; do
                test -f $i && ghc --make $i
              done
              ./Setup configure --verbose --prefix="$out"

              eval "$postConfigure"
            '';

            # builds via Cabal
            buildPhase = ''
              eval "$preBuild"

              ./Setup build

              eval "$postBuild"
            '';

	    # installs via Cabal; creates a registration file for nix-support
	    # so that the package can be used in other Haskell-builds; also
	    # creates a register-${name}.sh in userspace that can be used to
	    # register the library in a user environment (but this scheme
	    # should sooner or later be deprecated in favour of using a
	    # ghc-wrapper).
            installPhase = ''
              eval "$preInstall"

              ./Setup copy

              local confDir=$out/lib/ghc-pkgs/ghc-${attrs.ghc.ghc.version}
              ensureDir $confDir
              ./Setup register --gen-pkg-config=$confDir/${self.fname}.conf
              
              eval "$postInstall"
            '';
          };
    in  attrs.stdenv.mkDerivation ((rec { f = dtransform f // transform f; }).f);
} 
