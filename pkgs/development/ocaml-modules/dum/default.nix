{ lib, stdenv, fetchFromGitHub, ocaml, findlib
, easy-format
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-dum";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = "dum";
    rev = "v${version}";
    sha256 = "0yrxl97szjc0s2ghngs346x3y0xszx2chidgzxk93frjjpsr1mlr";
  };

  nativeBuildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ easy-format ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = with lib; {
    homepage = "https://github.com/mjambon/dum";
    description = "Inspect the runtime representation of arbitrary OCaml values";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.alexfmpe ];
  };
}
