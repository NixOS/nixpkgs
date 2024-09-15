{ lib, fetchFromGitHub, buildDunePackage
, alcotest, qcheck
}:

buildDunePackage rec {
  pname = "dates_calc";
  version = "0.0.6";

  minimalOCamlVersion = "4.11";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "catalalang";
    repo = "dates-calc";
    rev = version;
    sha256 = "sha256-B4li8vIK6AnPXJ1QSJ8rtr+JOcy4+h5sc1SH97U+Vgw=";
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
