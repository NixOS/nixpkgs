{ lib, mkCoqDerivation, coq, mathcomp-ssreflect, version ? null }:
with lib;

mkCoqDerivation {
  pname = "autosubst";

  release."1.7".rev    = "v1.7";
  release."1.7".sha256 = "sha256-qoyteQ5W2Noxf12uACOVeHhPLvgmTzrvEo6Ts+FKTGI=";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.10" "8.15"; out = "1.7"; }
  ] null;

  propagatedBuildInputs = [ mathcomp-ssreflect ];

  meta = {
    homepage = "https://www.ps.uni-saarland.de/autosubst/";
    description = "Automation for de Bruijn syntax and substitution in Coq";
    maintainers = with maintainers; [ siraben jwiegley ];
    license = licenses.mit;
  };
}
