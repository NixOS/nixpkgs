{ lib, fetchFromGitHub, buildOcaml, ocaml
, easy-format
}:

buildOcaml rec {
  name = "dum";
  version = "1.0.1";

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = name;
    rev = "v${version}";
    sha256 = "0yrxl97szjc0s2ghngs346x3y0xszx2chidgzxk93frjjpsr1mlr";
  };

  buildInputs = [ easy-format ];

  doCheck = true;

  meta = with lib; {
    homepage = https://github.com/mjambon/dum;
    description = "Inspect the runtime representation of arbitrary OCaml values";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.alexfmpe ];
  };
}
