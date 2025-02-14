{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "meteoalertapi";
  version = "0.3.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rolfberkenbosch";
    repo = "meteoalert-api";
    tag = "v${version}";
    hash = "sha256-Imb4DVcNB3QiVSCLCI+eKpfl73aMn4NIItQVf7p0H+E=";
  };

  propagatedBuildInputs = [
    requests
    xmltodict
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "meteoalertapi" ];

  meta = with lib; {
    description = "Python wrapper for MeteoAlarm.org";
    homepage = "https://github.com/rolfberkenbosch/meteoalert-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
