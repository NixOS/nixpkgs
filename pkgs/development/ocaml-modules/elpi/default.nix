{ lib, fetchFromGitHub, buildDunePackage, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

buildDunePackage rec {
  pname = "elpi";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = "elpi";
    rev = "v${version}";
    sha256 = "0740a9bg33g7r3injpalmn2jd0h586481vrrkdw46nsaspwcjhza";
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
