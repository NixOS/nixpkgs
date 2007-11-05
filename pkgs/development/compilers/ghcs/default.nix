{ ghcPkgUtil, gnum4, perl, ghcboot, stdenv, fetchurl, recurseIntoAttrs, gmp, readline, lib } : rec {
  
  /* What's in here?
     Goal:  really pure GHC. This means put every library into its each package.conf
     and add all together using GHC_PACKAGE_PATH

     First I've tried separating the build of ghc from it's lib. It hase been to painful. I've failed.
     Now there is splitpackagedb.hs which just takes the installed package.conf
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

  # creates a nix package out of the single package.conf files created when after installing ghc (see splitpackagedb.hs)
  packageByPackageDB = otherPkg : name : packageconfpath : propagatedBuildInputs : stdenv.mkDerivation {
    inherit name otherPkg propagatedBuildInputs;
    phases = "buildPhase fixupPhase";
    buildInputs = [ghcPkgUtil];
    buildPhase = "setupHookRegisteringPackageDatabase \"$otherPkg/${packageconfpath}\"
      ";
  };

  # used to automatically get dependencies ( used for core_libs ) 
  # TODO use kind of state and evaluate deps of a dep only once
  resolveDeps = ghc : libs : 
    let attrs = __listToAttrs libs; in
      rec {
        # using undocumented feature that attribute can contain hyphens when using listToAttrs
        # You should be able to get the attribute values using __getAttr
        result = __listToAttrs (map ( l : lib.av l.name (
                               packageByPackageDB ghc l.name 
                                      ("lib/ghc-${ghc.version}/${l.name}.conf")
                                      (map (n: __getAttr n result) l.deps)
                ) ) libs );
      }.result;


  
  #this only works for ghc-6.8 right now
  ghcAndLibraries = { version, src /* , core_libraries, extra_libraries  */
                    , extra_src }:
                   recurseIntoAttrs ( rec {
    inherit src extra_src version;

    ghc = stdenv.mkDerivation {
      name = "ghc-"+version;
      inherit src ghcboot gmp version;

      buildInputs = [readline perl gnum4 gmp];

      preConfigure = "
        chmod u+x rts/gmp/configure
        # still requires a hack for ncurses
        sed -i \"s|^\(library-dirs.*$\)|\1 \\\"$ncurses/lib\\\"|\" libraries/readline/package.conf.in
      ";

      splitpackagedb = ./splitpackagedb.hs;

      configurePhase = "./configure"
       +" --prefix=\$out "
       +" --with-ghc=\$ghcboot/bin/ghc"
       +" --with-gmp-libraries=$gmp/lib"
       +" --with-readline-libraries=\"$readline/lib\"";

      # now read the main package.conf and create a single package db file for each of them
      # Also create setup hook.

      #  note : I don't know yet wether it's a good idea to have RUNGHC.. It's faster
      # but you can't pass packages, can you?
      postInstall = "
        cp \$splitpackagedb splitpackagedb.hs
        \$out/bin/ghc-\$version --make -o splitpackagedb  splitpackagedb.hs;
        ./splitpackagedb \$out/lib/ghc-\$version/package.conf \$out/lib/ghc-\$version

        if test -x \$out/bin/runghc; then
          RUNHGHC=\$out/bin/runghc # > ghc-6.7/8 ?
        else
          RUNHGHC=\$out/bin/runhaskell # ghc-6.6 and prior 
        fi

        ensureDir \$out/nix-support
        sh=\$out/nix-support/setup-hook
        echo \"RUNHGHC=\$RUNHGHC\" >> \$sh
        
      ";
    };

    # Why this effort? If you want to use pretty-0.9 you can do this now without cabal choosing the 1.0 version hassle 
    core_libs = resolveDeps ghc
      [ { name = "Cabal-1.2.0"; deps = ["base-2.1" "pretty-1.0" "old-locale-1.0" "old-time-1.0" "directory-1.0" "unix-2.0" "process-1.0" "array-0.1" "containers-0.1" "rts-1.0" "filepath-1.0"];} #
        { name = "array-0.1"; deps = ["base-2.1"];}
        { name = "base-2.1"; deps = [];} #
        { name = "bytestring-0.9"; deps = [ "base-2.1" "array-0.1" ];}
        { name = "containers-0.1"; deps = [ "base-2.1" "array-0.1" ];}
        { name = "directory-1.0"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0" "filepath-1.0"];}
        { name = "filepath-1.0"; deps = [ "base-2.1" ];} #
        { name = "ghc-6.8.0.20071004"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0" "filepath-1.0" "directory-1.0" "array-0.1" "containers-0.1" "hpc-0.5" "bytestring-0.9" "pretty-1.0" "packedstring-0.1" "template-haskell-0.1" "unix-2.0" "process-1.0" "readline-1.0" "Cabal-1.2.0" "random-1.0" "haskell98-1.0"];}
        { name = "haskell98-1.0"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0" "filepath-1.0" "directory-1.0" "random-1.0" "unix-2.0" "process-1.0" "array-0.1"];}
        { name = "hpc-0.5"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0" "filepath-1.0" "directory-1.0" "array-0.1" "containers-0.1"]; }
        { name = "old-locale-1.0"; deps = [ "base-2.1"];}
        { name = "old-time-1.0"; deps = [ "base-2.1" "old-locale-1.0" ];}
        { name = "packedstring-0.1"; deps = [ "base-2.1" "array-0.1" ];}
        { name = "pretty-1.0"; deps = [ "base-2.1" ];}
        { name = "process-1.0"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0" "filepath-1.0" "directory-1.0" "unix-2.0"];}
        { name = "random-1.0"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0"];}
        { name = "readline-1.0"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0" "filepath-1.0" "directory-1.0" "unix-2.0" "process-1.0" ];}
        { name = "rts-1.0"; deps = [ "base-2.1" ];} #
        { name = "template-haskell-0.1"; deps = [ "base-2.1" "pretty-1.0" "array-0.1" "packedstring-0.1" "containers-0.1" ];}
        { name = "unix-2.0"; deps = [ "base-2.1" "old-locale-1.0" "old-time-1.0" "filepath-1.0" "directory-1.0" ];}
      ];

      

    extra_libs = [];

    #all_libs = core_libs ++ extra_libs;

  } );

  ghc68 = ghcAndLibraries {
    version = "6.8.0.20071004";
    src = fetchurl {
      url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.0.20071004-src.tar.bz2;
      sha256 = "1yyl7sxykmvkiwfxkfzpqa6cmgw19phkyjcdv99ml22j16wli63l";
      #url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.20070912-src.tar.bz2;
      #sha256 = "1b1gvi7hc7sc0fkh29qvzzd5lgnlvdv3ayiak4mkfnzkahvmq85s";
    };

    extra_src = fetchurl {
      url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.0.20071004-src-extralibs.tar.bz2;
      sha256 = "0vjx4vb2xhv5v2wj74ii3gpjim7x9wj0m87zglqlhc8xn31pmrd2";
      #url = http://www.haskell.org/ghc/dist/stable/dist/ghc-6.8.20070912-src-extralibs.tar.bz2;
      #sha256 = "0py7d9nh3lkhjxr3yb3n9345d0hmzq79bi40al5rcr3sb84rnp9r";
    };

    # this will change because of dependency hell :) 
    #core_libraries = [ "Cabal" /* "Win32" */ "array" "base" "bytestring" "containers" 
                       #"directory" "doc" "filepath" "haskell98" "hpc" "old-locale" "old-time"
                       #"packedstring" "pretty" "process" "random" "readline" "stamp" 
                       #"template-haskell" "unix" ];

    #extra_libraries = [ "ALUT" "GLUT" "HGL" "HUnit" "ObjectIO" "OpenAL" "OpenGL" "QuickCheck" "X11" 
                        #"arrows" "cgi" "fgl" "haskell-src" "html" "mtl" "network" "parallel" "parsec" 
                        #"regex-base" "regex-compat" "regex-posix" "stm" "time" "xhtm" ];

  };
}

