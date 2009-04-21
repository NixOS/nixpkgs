{stdenv, fetchurl, aterm, pkgconfig, getopt}:

rec {

  inherit aterm;
  

  sdf = stdenv.mkDerivation rec {
    name = "sdf2-bundle-2.3.3";

    src = fetchurl {
      url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.3.3/sdf2-bundle-2.3.3.tar.gz;
      md5 = "62ecabe5fbb8bbe043ee18470107ef88";
    };

    buildInputs = [pkgconfig aterm getopt];

    preConfigure = ''
      substituteInPlace pgen/src/sdf2table.src \
        --replace getopt ${getopt}/bin/getopt
    '';

    meta = {
      homepage = http://www.program-transformation.org/Sdf/SdfBundle;
      meta = "Tools for the SDF2 Syntax Definition Formalism, including the `pgen' parser generator and `sglr' parser";
    };
  };

  
  strategoxt = stdenv.mkDerivation {
    name = "strategoxt-0.16";

    src = fetchurl {
      url = ftp://ftp.strategoxt.org/pub/stratego/StrategoXT/strategoxt-0.16/strategoxt-0.16.tar.gz;
      md5 = "8b8eabbd785faa84ec20134b63d4829e";
    };

    buildInputs = [pkgconfig aterm sdf getopt];

    meta = {
      homepage = http://strategoxt.org/;
      meta = "A language and toolset for program transformation";
    };
  };
  
    
}
