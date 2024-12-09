{ lib, fetchFromGitHub, buildDunePackage, alcotest, bigstringaf }:

buildDunePackage rec {
  pname = "faraday";
  version = "0.8.2";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "sha256-wR4kDocR1t3OLRuudXH8IccYde552O6Gvo5BHNxRbAI=";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ bigstringaf ];
  doCheck = true;

  meta = {
    description = "Serialization library built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
