{ lib, mkCoqDerivation, coq, mathcomp-ssreflect, version ? null }:

mkCoqDerivation {
  pname = "autosubst";

  release."1.7".rev    = "v1.7";
  release."1.7".sha256 = "sha256-qoyteQ5W2Noxf12uACOVeHhPLvgmTzrvEo6Ts+FKTGI=";
  release."1.9".rev    = "v1.9";
  release."1.9".sha256 = "sha256-XiLZjMc+1iwRGOstfLm/WQRF6FTdX6oJr5urn3wmLlA=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.10" "8.13"; out = "1.7"; }
    { case = range "8.14" "8.20"; out = "1.9"; }
  ] null;

  propagatedBuildInputs = [ mathcomp-ssreflect ];

  meta = with lib; {
    homepage = "https://www.ps.uni-saarland.de/autosubst/";
    description = "Automation for de Bruijn syntax and substitution in Coq";
    maintainers = with maintainers; [ siraben jwiegley ];
    license = licenses.mit;
  };
}
