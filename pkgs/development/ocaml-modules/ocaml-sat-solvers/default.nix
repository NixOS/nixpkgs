{
  lib,
  fetchFromGitHub,
  buildOasisPackage,
  minisat,
}:

buildOasisPackage rec {
  pname = "ocaml-sat-solvers";
  version = "0.4";

  minimumOCamlVersion = "4.03.0";

  src = fetchFromGitHub {
    owner = "tcsprojects";
    repo = "ocaml-sat-solvers";
    rev = "v${version}";
    sha256 = "1hxr16cyl1p1k1cik848mqrysq95wxmlykpm93a99pn55mp28938";
  };

  propagatedBuildInputs = [ minisat ];

  meta = {
    homepage = "https://github.com/tcsprojects/ocaml-sat-solvers";
    description = "SAT Solvers For OCaml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
