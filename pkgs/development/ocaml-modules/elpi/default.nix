{ lib, fetchzip, buildDunePackage, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

buildDunePackage rec {
  pname = "elpi";
  version = "1.11.2";

   src = fetchzip {
     url = "https://github.com/LPCIC/elpi/releases/download/v${version}/elpi-v${version}.tbz";
     sha256 = "15hamy9ifr05kczadwh3yj2gmr12a9z1jwppmp5yrns0vykjbj76";
   };

  minimumOCamlVersion = "4.04";

  buildInputs = [ ppx_tools_versioned ];

  propagatedBuildInputs = [ camlp5 ppx_deriving re ];

  meta = {
    description = "Embeddable λProlog Interpreter";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/LPCIC/elpi";
  };

  useDune2 = true;
}
