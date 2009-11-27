{stdenv, fetchurl, aterm, pkgconfig, getopt, jdk, readline}:

rec {

  inherit aterm;

  
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
    name = "strategoxt-0.17";

    src = fetchurl {
      url = "ftp://ftp.strategoxt.org/pub/stratego/StrategoXT/strategoxt-0.17/strategoxt-0.17.tar.gz";
      sha256 = "70355576c3ce3c5a8a26435705a49cf7d13e91eada974a654534d63e0d34acdb";
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
      url = "ftp://ftp.strategoxt.org/pub/stratego/StrategoXT/strategoxt-0.17/stratego-shell-0.17.tar.gz";
      sha256 = "0q21vks9gaw9v4rxz90wb0pxzb19l7gwi4nbjvk4zb1imdk7znck";
    };

    buildInputs = [pkgconfig aterm sdf strategoxt getopt];

    meta = {
      homepage = http://strategoxt.org/;
      meta = "A language and toolset for program transformation";
    };
  };


  javafront = stdenv.mkDerivation (rec {
    name = "java-front-0.9";

    src = fetchurl {
      url = "ftp://ftp.strategoxt.org/pub/stratego/java-front/java-front-0.9/java-front-0.9.tar.gz";
      sha256 = "96f40bf31486d3ced3ecebdcc0067e83ce6acbdbe57e3c847136ac3d7b62cc3c";
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
