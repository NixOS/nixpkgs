{ lib
, buildDunePackage
, fetchFromGitHub
, alcotest
, qcheck-core
}:

buildDunePackage rec {
  pname = "algaeff";
  version = "2.0.0";

  minimalOCamlVersion = "5.0";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    hash = "sha256-VRZfULbXKRcExU1bnEu/X1KPX+L+dzcRYZVD985rQT4=";
  };

  doCheck = true;
  checkInputs = [ alcotest qcheck-core ];

  meta = {
    description = "Reusable Effects-Based Components";
    homepage = "https://github.com/RedPRL/algaeff";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
