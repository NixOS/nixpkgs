{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, inflection, requests
, urllib3, six, certifi, pyopenssl, tldextract, python-dateutil }:

buildPythonPackage rec {
  pname = "kicost-digikey-api-v3";
  version = "0.1.2";

  src = fetchPypi {
    inherit version;
    pname = "kicost_digikey_api_v3";
    sha256 = "sha256-tOHiv1CbcfCgWjqZ29DchAfxVgemKZviEbHVZA34ZAw=";
  };

  propagatedBuildInputs = [
    inflection
    requests
    urllib3
    six
    certifi
    pyopenssl
    tldextract
    python-dateutil
  ];

  # Tests missing in source distribution
  doCheck = false;
  pythonImportsCheck = [ "kicost_digikey_api_v3" ];

  meta = with lib; {
    description = "KiCost plugin for the Digikey PartSearch API";
    homepage = "https://github.com/set-soft/kicost-digikey-api-v3";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sephalon ];
  };
}
