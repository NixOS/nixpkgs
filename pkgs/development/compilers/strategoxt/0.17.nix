{stdenv, fetchurl, aterm, pkgconfig, getopt, jdk}:

rec {

  inherit aterm;

  
  sdf = stdenv.mkDerivation rec {
    name = "sdf2-bundle-2.4pre212034";

    src = fetchurl {
      url = "http://releases.strategoxt.org/strategoxt-0.17/sdf2-bundle/${name}-37nm9z7p/sdf2-bundle-2.4.tar.gz";
      sha256 = "2ec83151173378f48a3326e905d11049d094bf9f0c7cff781bc2fce0f3afbc11";
    };

    buildInputs = [pkgconfig aterm];

    preConfigure = ''
      substituteInPlace pgen/src/sdf2table.src \
        --replace getopt ${getopt}/bin/getopt
    '';

    configureFlags = "--disable-static";

    meta = {
      homepage = http://www.program-transformation.org/Sdf/SdfBundle;
      meta = "Tools for the SDF2 Syntax Definition Formalism, including the `pgen' parser generator and `sglr' parser";
    };
  };

  
  strategoxt = stdenv.mkDerivation rec {
    name = "strategoxt-0.17pre18269";

    src = fetchurl {
      url = "http://releases.strategoxt.org/strategoxt/${name}-a0f0wy0j/${name}.tar.gz";
      sha256 = "7c51c2452bd45f34cd480b6b3cbaac50e0fc53fbb1a884d97cf4e2c2b5330577";
    };

    buildInputs = [pkgconfig aterm sdf getopt];

    configureFlags = "--disable-static";

    meta = {
      homepage = http://strategoxt.org/;
      meta = "A language and toolset for program transformation";
    };
  };


  javafront = stdenv.mkDerivation rec {
    name = "java-front-0.9pre1823618236";

    src = fetchurl {
      url = "http://releases.strategoxt.org/java-front/${name}-frb8zh7m/java-front-0.9pre18236.tar.gz";
      sha256 = "93d2919cfbda41a96a944f71ae57704ad1f0efcc0c1084b501a4536f82e25387";
    };

    buildInputs = [pkgconfig aterm sdf strategoxt];

    # !!! The explicit `--with-strategoxt' is necessary; otherwise we
    # get an XTC registration that refers to "/share/strategoxt/XTC".
    configureFlags = "--disable-static --enable-xtc --with-strategoxt=${strategoxt}";

    meta = {
      homepage = http://strategoxt.org/Stratego/JavaFront;
      meta = "Tools for generating or transforming Java code";
    };
  };


  dryad = stdenv.mkDerivation rec {
    name = "dryad-0.2pre1835518355";

    src = fetchurl {
      url = "http://releases.strategoxt.org/dryad/${name}-zbqfh1rm/dryad-0.2pre18355.tar.gz";
      sha256 = "2c27b7f82f87ffc27b75969acc365560651275d348b3b5cbb530276d20ae83ab";
    };

    buildInputs = [jdk pkgconfig aterm sdf strategoxt javafront];

    configureFlags = "--disable-static";

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
