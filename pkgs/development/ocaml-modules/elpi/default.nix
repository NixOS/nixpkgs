{ lib, fetchFromGitHub, buildDunePackage, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

buildDunePackage rec {
  pname = "elpi";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = "elpi";
    rev = "v${version}";
    sha256 = "1q6s3x4gba0hdymlgj4rf1bny4v7ac4jj7q134cwd3sxiwqcyhww";
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
