{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
  qcheck-core,
}:

buildDunePackage rec {
  pname = "algaeff";
  version = "1.1.0";

  minimalOCamlVersion = "5.0";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    hash = "sha256-7kwQmoT8rpQWPHc+BZQi9fcZhgHxS99158ebXAXlpQ8=";
  };

  doCheck = true;
  checkInputs = [
    alcotest
    qcheck-core
  ];

  meta = {
    description = "Reusable Effects-Based Components";
    homepage = "https://github.com/RedPRL/algaeff";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
