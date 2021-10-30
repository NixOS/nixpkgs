{ lib
, fetchFromGitHub
, buildDunePackage
, cmdliner
, menhir
, menhirLib
, ppx_deriving
, ppxlib
, uuseg
, uutf
}:

buildDunePackage {
  pname = "cooltt";
  version = "unstable-2021-05-25";

  minimumOCamlVersion = "4.10";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "cooltt";
    rev = "8ac06cbf7e05417d777f3ac6a471fe3576249f79";
    sha256 = "sha256-JBLNJaRuP/gwlg8RS3cpOpzxChOVKfmFulf5HKhhHh4=";
  };

  nativeBuildInputs = [
    cmdliner
    menhir
    ppxlib
  ];

  propagatedBuildInputs = [
    menhirLib
    ppx_deriving
    uuseg
    uutf
  ];

  meta = with lib; {
    homepage = "https://github.com/RedPRL/cooltt";
    description = "A cool implementation of normalization by evaluation (nbe) & elaboration for Cartesian cubical type theory";
    license = licenses.asl20;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
