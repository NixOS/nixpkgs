{ lib
, buildDunePackage
, fetchFromGitHub
}:

buildDunePackage rec {
  pname = "algaeff";
  version = "0.2.1";

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    hash = "sha256-jpnJhF+LN2ef6QPLcCHxcMg3Fr3GSLOnJkZ9ZUIOrlY=";
  };

  meta = {
    description = "Reusable Effects-Based Components";
    homepage = "https://github.com/RedPRL/algaeff";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
