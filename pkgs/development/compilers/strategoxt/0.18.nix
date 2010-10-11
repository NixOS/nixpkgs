{stdenv, fetchurl, aterm, pkgconfig, getopt, jdk, makeStaticBinaries, readline, ncurses}:

rec {

  inherit aterm;

  atermStatic = stdenv.mkDerivation ( rec {
    name = "${aterm.name}-static";
    configureFlags = "--enable-shared=no --enable-static=yes";

    inherit (aterm) src meta patches; 
  } // ( if stdenv.system == "i686-cygwin" then { inherit (sdf) CFLAGS; } else {} ) ) ;
  
  sdfStatic = stdenv.mkDerivation ( rec {
    name = "${sdf.name}-static";
    configureFlags = "--enable-shared=no --enable-static=yes";

    inherit (sdf) src buildInputs preConfigure meta; 
  } // ( if stdenv.system == "i686-cygwin" then { inherit (sdf) CFLAGS; } else {} ) ) ;
  
  sdf = stdenv.mkDerivation ( rec {
    name = "sdf2-bundle-2.4";

    src = fetchurl {
      url = "ftp://ftp.strategoxt.org/pub/stratego/StrategoXT/strategoxt-0.17/sdf2-bundle-2.4.tar.gz";
      sha256 = "2ec83151173378f48a3326e905d11049d094bf9f0c7cff781bc2fce0f3afbc11";
    };

    buildInputs = [pkgconfig aterm];

    preConfigure = ''
      substituteInPlace pgen/src/sdf2table.src \
        --replace getopt ${getopt}/bin/getopt
    '';

    meta = {
      homepage = http://www.program-transformation.org/Sdf/SdfBundle;
      meta = "Tools for the SDF2 Syntax Definition Formalism, including the `pgen' parser generator and `sglr' parser";
    };
  } // ( if stdenv.system == "i686-cygwin" then { CFLAGS = "-O2 -Wl,--stack=0x2300000"; } else {} ) ) ;

  
  strategoxt = stdenv.mkDerivation rec {
    name = "strategoxt-0.18pre21134";

    src = fetchurl {
      url = http://hydra.nixos.org/build/665485/download/1/strategoxt-1.8pre21134.tar.gz;
      sha256 = "105ce9a424551cf007e354eac181aafb352713e79cf1735a73564984c3635e53";
    };

    buildInputs = [pkgconfig aterm sdf getopt];

    meta = {
      homepage = http://strategoxt.org/;
      meta = "A language and toolset for program transformation";
    };
  };

  strategoShell = stdenv.mkDerivation rec {
    name = "stratego-shell-0.7";

    src = fetchurl {
      url = "ftp://ftp.strategoxt.org/pub/stratego/StrategoXT/strategoxt-0.17/stratego-shell-0.7.tar.gz";
      sha256 = "0q21vks9gaw9v4rxz90wb0pxzb19l7gwi4nbjvk4zb1imdk7znck";
    };

    buildInputs = [pkgconfig aterm sdf strategoxt getopt readline ncurses];

    meta = {
      homepage = http://strategoxt.org/;
      meta = "A language and toolset for program transformation";
    };
  };

  javafront = stdenv.mkDerivation (rec {
    name = "java-front-0.9";

    src = fetchurl {
      url = "http://hydra.nixos.org/build/79602/download/1/java-front-0.9.1pre19993.tar.gz";
      sha256 = "e07e7d9ecc4a57c24d7af309d576d6eda75cb07a9d3d06594edfded366863c9c";
    };

    buildInputs = [pkgconfig aterm sdf strategoxt];

    # !!! The explicit `--with-strategoxt' is necessary; otherwise we
    # get an XTC registration that refers to "/share/strategoxt/XTC".
    configureFlags = "--enable-xtc --with-strategoxt=${strategoxt}";

    meta = {
      homepage = http://strategoxt.org/Stratego/JavaFront;
      meta = "Tools for generating or transforming Java code";
    };
  } // ( if stdenv.system == "i686-cygwin" then { CFLAGS = "-O2"; } else {} ) ) ;


  aspectjfront = stdenv.mkDerivation (rec {
    name = "aspectj-front-0.2pre20035";

    src = fetchurl {
      url = "http://hydra.nixos.org/build/175690/download/1/aspectj-front-0.2pre20035.tar.gz";
      sha256 = "48f6cda6f9f19436e9553e8d27e6bb42500d08370332e3ad214affb49851e58e";
    };

    buildInputs = [pkgconfig aterm sdf strategoxt javafront];

  } // ( if stdenv.system == "i686-cygwin" then { CFLAGS = "-O2"; } else {} ) ) ;

  dryad = stdenv.mkDerivation rec {
    name = "dryad-0.2pre1835518355";

    src = fetchurl {
      url = "http://releases.strategoxt.org/dryad/${name}-zbqfh1rm/dryad-0.2pre18355.tar.gz";
      sha256 = "2c27b7f82f87ffc27b75969acc365560651275d348b3b5cbb530276d20ae83ab";
    };

    buildInputs = [jdk pkgconfig aterm sdf strategoxt javafront];

    meta = {
      homepage = http://strategoxt.org/Stratego/TheDryad;
      meta = "A collection of tools for developing transformation systems for Java source and bytecode";
    };
  };


  /*
  libraries = ... {
    configureFlags =
      if stdenv ? isMinGW && stdenv.isMinGW then "--with-std=C99" else "";

    # avoids loads of warnings about too big description fields because of a broken debug format
    CFLAGS =
      if stdenv ? isMinGW && stdenv.isMinGW then "-O2" else null;
  };
  */
  
}
