{ lib, fetchFromGitHub, buildDunePackage, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

buildDunePackage rec {
  pname = "elpi";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = "elpi";
    rev = "v${version}";
    sha256 = "0w5z0pxyshqawq7w5rw3nqii49y88rizvwqf202pl11xqi14icsn";
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
