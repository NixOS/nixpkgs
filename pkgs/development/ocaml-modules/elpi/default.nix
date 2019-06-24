{ lib, fetchFromGitHub, buildDunePackage, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

buildDunePackage rec {
  pname = "elpi";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = pname;
    rev = "v${version}";
    sha256 = "08ddi1gkavy2y8375nvg4sgzqdirw82f086z95axzf2097hm3x1q";
  };

  minimumOCamlVersion = "4.04";

  buildInputs = [ ppx_tools_versioned ];

  propagatedBuildInputs = [ camlp5 ppx_deriving re ];

  meta = {
    description = "Embeddable λProlog Interpreter";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
