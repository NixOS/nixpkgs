{ lib, mkCoqDerivation, coq, mathcomp-ssreflect,
  version ? null, origin ? null }:
with lib;

mkCoqDerivation {
  pname   = "autosubst";
  owner   = "uds-psl";
  inherit version origin;

  release."1.7".rev    = "v1.7";
  release."1.7".sha256 = "sha256-qoyteQ5W2Noxf12uACOVeHhPLvgmTzrvEo6Ts+FKTGI=";

  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.10";       out = "1.7"; }
    { case = range "8.5" "8.7"; out = "5b40a32e"; }
  ] null;

  propagatedBuildInputs = [ mathcomp-ssreflect ];

  meta = {
    homepage = "https://www.ps.uni-saarland.de/autosubst/";
    description = "Automation for de Bruijn syntax and substitution in Coq";
    maintainers = with maintainers; [ siraben jwiegley ];
    license = licenses.mit;
  };
}
