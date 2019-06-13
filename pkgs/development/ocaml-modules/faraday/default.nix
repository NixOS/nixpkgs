{ lib, fetchFromGitHub, buildDunePackage, alcotest, bigstringaf }:

buildDunePackage rec {
  pname = "faraday";
  version = "0.7.0";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "0z6ikwlqad91iac0q5z88p3wzq5k15y86ckzmhdq1aqwrcm14bq2";
  };

  buildInputs = [ alcotest ];
  propagatedBuildInputs = [ bigstringaf ];
  doCheck = true;

  meta = {
    description = "Serialization library built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
