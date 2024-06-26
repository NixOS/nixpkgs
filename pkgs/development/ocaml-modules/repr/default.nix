{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  base64,
  either,
  fmt,
  jsonm,
  uutf,
  optint,
}:

buildDunePackage rec {
  pname = "repr";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "repr";
    rev = version;
    hash = "sha256-SM55m5NIaQ2UKAtznNFSt3LN4QA7As0DyTxVeQjOTjI=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    base64
    either
    fmt
    jsonm
    uutf
    optint
  ];

  meta = with lib; {
    description = "Dynamic type representations. Provides no stability guarantee";
    homepage = "https://github.com/mirage/repr";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
