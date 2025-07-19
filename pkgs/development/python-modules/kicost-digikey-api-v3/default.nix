{ lib, buildPythonPackage, fetchFromGitHub, python3Packages }:

buildPythonPackage rec {
  pname = "kicost-digikey-api-v3";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "set-soft";
    repo = "kicost-digikey-api-v3";
    rev = "v${version}";
    hash = "sha256-O4bYvf8EnAlcgJ/fqYEuo2+37Q6lTdmlSrmaD2Cl/q8=";
  };

  dependencies = with python3Packages; [
    inflection
    requests
    urllib3
    six
    certifi
    pyopenssl
    tldextract
    python-dateutil
  ];

  doCheck = false;
  pythonImportsCheck = [ "kicost_digikey_api_v3" ];

  meta = with lib; {
    description = "KiCost plugin for the Digikey PartSearch API";
    homepage = "https://github.com/set-soft/kicost-digikey-api-v3";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sephalon ldenefle ];
  };
}
