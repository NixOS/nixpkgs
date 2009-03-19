{stdenv, fetchurl, aterm, pkgconfig, getopt}:

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
