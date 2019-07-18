{ lib, fetchFromGitHub, buildDunePackage, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

buildDunePackage rec {
  pname = "elpi";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = "elpi";
    rev = "v${version}";
    sha256 = "0sj2jbimg3jqwz4bsfcdqbrh45bb1dbgxj5g234pg1xjy9kxzl2w";
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
