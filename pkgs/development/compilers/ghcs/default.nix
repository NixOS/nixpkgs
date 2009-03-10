  { ghcPkgUtil, gnum4, perl, ghcboot, stdenv, fetchurl, recurseIntoAttrs, gmp, readline, lib, hasktags, ctags
    , sourceByName, autoconf, happy, alex ,automake, getConfig} : 
rec {
  
  /* What's in here?
     Goal:  really pure GHC. This means put every library into its each package.conf
     and add all together using GHC_PACKAGE_PATH

     First I've tried separating the build of ghc from it's lib. It hase been to painful. I've failed.  Now there is nix_ghc_pkg_tool.hs which just takes the installed package.conf
     and creates a new package db file for each contained package.

     The final attribute set looks similar to this:
     ghc, core_libs and extra_libraries will then be used to build all the ohter packages availible on hackege..
     (There is much left to be done)

     ghcAndLibraries =  {
      ghc68 = {
        ghc = {
          src = "The compiler source"
          extra_src =  "source of extra libraries"
          version = "GHC version as string"
        }

        core_libs = [ libs distributed the ghc core (see libraries/core-packages ];
        extra_libraries = [ libraries contained extra_src ];
     };

     ghc66 = {
       roughly the same
     };
    }

  */

  #this only works for ghc-6.8 right now
  ghcAndLibraries = { version, src /* , core_libraries, extra_libraries  */
                    , extra_src, pass ? {} }:
                   recurseIntoAttrs ( rec {
    inherit src extra_src version;

    ghc = stdenv.mkDerivation ( lib.mergeAttrsNoOverride {} pass {
      name = "ghc-"+version;
      inherit src ghcboot gmp version;

      buildInputs = [readline perl gnum4 gmp];

      preConfigure = "
        chmod u+x rts/gmp/configure
        # still requires a hack for ncurses
        sed -i \"s|^\(library-dirs.*$\)|\1 \\\"$ncurses/lib\\\"|\" libraries/readline/package.conf.in
      ";

      # TODO add unique (filter duplicates?) shouldn't be there? 
      nix_ghc_pkg_tool = ./nix_ghc_pkg_tool.hs;

      configurePhase = "./configure"
       +" --prefix=\$out "
       +" --with-ghc=\$ghcboot/bin/ghc"
       +" --with-gmp-libraries=$gmp/lib"
       +" --with-gmp-includes=${gmp}/include"
       +" --with-readline-libraries=\"$readline/lib\"";

      # now read the main package.conf and create a single package db file for each of them
      # Also create setup hook.
      makeFlags = getConfig ["ghc" "makeFlags" ] "";

      #  note : I don't know yet wether it's a good idea to have RUNGHC.. It's faster
      # but you can't pass packages, can you?
      postInstall = "
        cp \$nix_ghc_pkg_tool nix_ghc_pkg_tool.hs
        \$out/bin/ghc-\$version --make -o nix_ghc_pkg_tool  nix_ghc_pkg_tool.hs;
        ./nix_ghc_pkg_tool split \$out/lib/ghc-\$version/package.conf \$out/lib/ghc-\$version
        cp nix_ghc_pkg_tool \$out/bin

        if test -x \$out/bin/runghc; then
          RUNHGHC=\$out/bin/runghc # > ghc-6.7/8 ?
        else
          RUNHGHC=\$out/bin/runhaskell # ghc-6.6 and prior 
        fi

        ensureDir \$out/nix-support
        sh=\$out/nix-support/setup-hook
        echo \"RUNHGHC=\$RUNHGHC\" >> \$sh
        
      ";
    });

    core_libs = rec {
        #   name (using lowercase letters everywhere because using installing packages having different capitalization is discouraged) - this way there is not that much to remember?

        cabal_darcs_name = "cabal-darcs";

        # introducing p here to speed things up.
        # It merges derivations (defined below) and additional inputs. I hope that using as few nix functions as possible results in greates speed?
        # unfortunately with x; won't work because it forces nix to evaluate all attributes of x which would lead to infinite recursion
        pkgs = let x = derivations; in {
            # ghc extra packages 
          cabal = { name = "Cabal-1.2.3.0"; srcDir = "libraries/Cabal";
                          deps = [x.base x.pretty x.old_locale x.old_time
                            x.directory x.unix x.process x.array x.containers
                            x.rts x.filepath ]; };
          array = { name = "array-0.1.0.0"; srcDir = "libraries/array";
                          deps = [x.base ]; };
          base = { name = "base-3.0.1.0"; srcDir = "libraries/base";
                          deps = [x.rts ]; };
          bytestring = { name = "bytestring-0.9.0.1"; srcDir = "libraries/bytestring";
                          deps = [ x.base x.array ];};
          containers = { name = "containers-0.1.0.1"; srcDir = "libraries/containers";
                          deps = [ x.base x.array ];};
          directory = { name = "directory-1.0.0.0"; srcDir = "libraries/directory";
                          deps = [ x.base x.old_locale x.old_time x.filepath ];};
          filepath = { name = "filepath-1.1.0.0"; srcDir = "libraries/filepath";
                          deps = [ x.base ];};
          ghc = { name = "ghc-${version}"; srcDir = "compiler";
                          deps = [ x.base x.old_locale x.old_time x.filepath
                            x.directory x.array x.containers x.hpc x.bytestring
                            x.pretty x.packedstring x.template_haskell x.unix
                            x.process x.readline x.cabal x.random x.haskell98 ]; };
          haskell98 = { name = "haskell98-1.0.1.0"; srcDir = "libraries/haskell98";
                          deps = [ x.base x.old_locale x.old_time x.filepath
                            x.directory x.random x.unix x.process x.array]; };
          hpc = { name = "hpc-0.5.0.0"; srcDir = "libraries/hpc";
                          deps = [ x.base x.old_locale x.old_time x.filepath
                            x.directory x.array x.containers ]; };
          old_locale = { name = "old-locale-1.0.0.0"; srcDir = "libraries/old-locale";
                          deps = [ x.base ]; };
          old_time = { name = "old-time-1.0.0.0"; srcDir = "libraries/old-time";
                          deps = [ x.base x.old_locale ];};
          packedstring = { name = "packedstring-0.1.0.0"; srcDir = "libraries/packedstring";
                          deps = [ x.base x.array ];};
          pretty = { name = "pretty-1.0.0.0"; srcDir = "libraries/pretty";
                          deps = [ x.base ];};
          process = { name = "process-1.0.0.0"; srcDir = "libraries/process";
                          deps = [ x.base x.old_locale x.old_time x.filepath
                            x.directory x.unix ]; };
          random = { name = "random-1.0.0.0"; srcDir = "libraries/random";
                          deps = [ x.base x.old_locale x.old_time ]; };
          readline = { name = "readline-1.0.1.0"; srcDir = "libraries/readline";
                          deps = [ x.base x.old_locale x.old_time x.filepath
                            x.directory x.unix x.process ];};
          rts = rec { 
                  name = "rts-1.0"; srcDir = "rts"; # TODO: Doesn't have .hs files so I should use ctags if creating tags at all
                  deps = [];
                  createTagFiles = [
                      { name = "${name}_haskell";
                        tagCmd = "${toString ctags}/bin/ctags -R .;mv tags \$TAG_FILE"; }
                    ];
          };
          template_haskell = { name = "template-haskell-2.2.0.0"; srcDir = "libraries/template-haskell";
                          deps = [ x.base x.pretty x.array x.packedstring x.containers ];};
          unix = { name = "unix-2.3.0.0"; srcDir = "libraries/unix";
                          deps = [ x.base x.old_locale x.old_time x.filepath x.directory ];};
        };

        toDerivation = attrs : with attrs;

                stdenv.mkDerivation {
                    inherit (attrs) name;
                    phases = "buildPhase fixupPhase";
                    buildInputs = [ ghcPkgUtil ];
                    propagatedBuildInputs = [ ghc ] ++ attrs.deps;
                    buildPhase = "setupHookRegisteringPackageDatabase \"${ghc}/lib/ghc-${ghc.version}/${attrs.name}.conf\"";
                    meta = {
                      sourceWithTags = {
                        src = ghc.src;
                        inherit srcDir;
                        name = attrs.name + "-src-with-tags";
                        createTagFiles = lib.maybeAttr "createTagFiles" [
                            { name = "${attrs.name}_haskell";
                              tagCmd = "${toString hasktags}/bin/hasktags-modified --ctags `find . -type f -name \"*.*hs\"`; sort tags > \$TAG_FILE"; } 
                          ] attrs;
                      };
                    };
          };
        derivations = with lib; builtins.listToAttrs (lib.concatLists ( lib.mapRecordFlatten 
                  ( n : attrs : let d = (toDerivation attrs); in [ (nameValuePair n d) (nameValuePair attrs.name d) ] ) pkgs ) );
    }.derivations;
  });

  ghc68 = ghcAndLibraries rec {
    version = "6.8.2";
    src = fetchurl {
      #url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.0.20071004-src.tar.bz2;
      #sha256 = "1yyl7sxykmvkiwfxkfzpqa6cmgw19phkyjcdv99ml22j16wli63l";
      url = "http://www.haskell.org/ghc/dist/stable/dist/ghc-${version}-src.tar.bz2";
      md5 = "745c6b7d4370610244419cbfec4b2f84";
      #url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.20070912-src.tar.bz2;
      #sha256 = "1b1gvi7hc7sc0fkh29qvzzd5lgnlvdv3ayiak4mkfnzkahvmq85s";
    };

    pass = { patches = ./patch; };

    extra_src = fetchurl {
      url = "http://www.haskell.org/ghc/dist/stable/dist/ghc-${version}-src-extralibs.tar.bz2";
      sha256 = "044mpbzpkbxcnqhjnrnmjs00mr85057d123rrlz2vch795lxbkcn";
      #url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.20070912-src-extralibs.tar.bz2;
      #sha256 = "0py7d9nh3lkhjxr3yb3n9345d0hmzq79bi40al5rcr3sb84rnp9r";
    };
  };

  # this works. commented out because I haven't uploaded all the bleeding edge source dist files.
  #[> darcs version of ghc which is updated occasionally by Marc Weber 
  #ghc68darcs = ghcAndLibraries rec {
  #  version = "6.9";

  #  pass = { buildInputs = [ happy alex]; 
  #           patches =  ./patch;
  #           patchPhase = "
  #             unset patchPhase; patchPhase
  #             pwd
  #             sed 's/GhcWithJavaGen=NO/GhcWithJavaGen=YES/g' -i mk/config.mk.in
  #             ";
  #  };
  #  [> each library is usually added using darcs-all get 
  #  [> so I assemble and prepare the sources here
  #  src = stdenv.mkDerivation {
  #    name = "ghc-darcs-src-dist";
  #    buildInputs = [autoconf automake];
  #    core_libs = map (x : sourceByName "ghc_core_${x}") ["array" "base" "bytestring" "Cabal" "containers" "directory" "editline" "filepath" "ghc_prim" "haskell98" "hpc" "integer_gmp" "old_locale" "old_time" "packedstring" "pretty" "process" "random" "template_haskell" "unix" "Win32" ];
  #    ghc = sourceByName "ghc";
  #    phases = "buildPhase";
  #    buildPhase = "
  #      echo unpacking ghc
  #      tar xfz \$ghc &> /dev/null
  #      cd nix_repsoitory_manager_tmp_dir/libraries
  #      for i in \$core_libs; do
  #        echo 'unpacking core_lib :' \$i
  #        tar  xfz \$i &> /dev/null
  #        n=`basename \$i`
  #        n=\${n/ghc_core_/}
  #        if [ -f nix_repsoitory_manager_tmp_dir/*.ac ]; then
  #          cd nix_repsoitory_manager_tmp_dir
  #          echo   =======================================================
  #          echo \$n
  #          autoreconf
  #          cd ..
  #        fi
  #        mv nix_repsoitory_manager_tmp_dir \${n/.tar.gz/}
  #      done
  #      mv ghc_prim ghc-prim
  #      for i in integer-gmp old-locale old-time template-haskell; do
  #        mv \${i/-/_} $i
  #      done
  #      mkdir \$out
  #      cd ..
  #      autoreconf
  #      sh boot
  #      cd ..
  #      mv nix*/* \$out/
  #    ";
  #  };

  #  [> TODO this is copied.. use dev versions as well here
  #  extra_src = fetchurl {
  #    url = "http://www.haskell.org/ghc/dist/stable/dist/ghc-${version}-src-extralibs.tar.bz2";
  #    sha256 = "044mpbzpkbxcnqhjnrnmjs00mr85057d123rrlz2vch795lxbkcn";
  #    [>url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.20070912-src-extralibs.tar.bz2;
  #    [>sha256 = "0py7d9nh3lkhjxr3yb3n9345d0hmzq79bi40al5rcr3sb84rnp9r";
  #  };
  #};
}
