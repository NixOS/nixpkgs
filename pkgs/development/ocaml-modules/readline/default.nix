{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  readline,
}:

buildDunePackage {
  pname = "readline";
  version = "0.2";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "acg";
    repo = "dev/readline-ocaml";
    tag = "v0.2";
    hash = "sha256-qWxciodgINCFCxAVLdoU4z+ypWPYjrUwq8pU80saclw=";
  };

  patches = [ ./dune.patch ];

  preConfigure = ''
    echo "(${lib.getOutput "dev" readline}/include)" > src/iflags.sexp
    echo "(-L${lib.getOutput "lib" readline}/lib -lreadline)" > src/lflags.sexp
  '';

  propagatedBuildInputs = [ readline ];

  meta = {
    description = "OCaml bindings for GNU Readline";
    homepage = "https://acg.gitlabpages.inria.fr/dev/readline-ocaml/readline/index.html";
    license = lib.licenses.cecill20;
    maintainers = [ lib.maintainers.tournev ];
  };
}
