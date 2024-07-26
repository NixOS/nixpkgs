{ lib, fetchFromGitHub, buildDunePackage
, alcotest, qcheck
}:

buildDunePackage rec {
  pname = "dates_calc";
  version = "0.0.4";

  minimalOCamlVersion = "4.11";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "catalalang";
    repo = "dates-calc";
    rev = version;
    sha256 = "sha256-tpKOoPVXkg/k+NW5R8A4fGAKhdMn9UcqMogCjafJuw4=";
  };

  propagatedBuildInputs = [];

  doCheck = true;
  checkInputs = [
    alcotest
    qcheck
  ];

  meta = {
    description = "Date calculation library";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.niols ];
    homepage = "https://github.com/catalalang/dates-calc";
  };
}
