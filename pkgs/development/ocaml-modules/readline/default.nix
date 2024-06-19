{ lib, buildDunePackage, fetchFromGitLab
, readline
}:

buildDunePackage {
  pname = "readline";
  version = "0.1";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "vtourneu";
    repo = "readline-ocaml";
    rev = "b3f84c8a006439142884d3e0df51b395d963f9fe";
    hash = "sha256-h4kGbzwM88rPGj/KkHKgGyfyvkAYHP83ZY1INZzTaIE=";
  };

  patches = [ ./dune.patch ];

  preConfigure = ''
    echo "(${lib.getOutput "dev" readline}/include)" > src/iflags.sexp
    echo "(-L${lib.getOutput "lib" readline}/lib -lreadline)" > src/lflags.sexp
  '';

  propagatedBuildInputs = [ readline ];

  meta = {
    description = "OCaml bindings for GNU Readline";
    homepage = "https://vtourneu.gitlabpages.inria.fr/readline-ocaml/readline/index.html";
    license = lib.licenses.cecill20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
