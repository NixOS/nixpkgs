{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B53KWIVt7mZG7VovIoOAnBbS3u3eHp6WFbKRAySkuWk=";
  };

  propagatedBuildInputs = [
    pyhcl
    requests
    six
  ];

  # Requires running a Vault server
  doCheck = false;

  pythonImportsCheck = [ "hvac" ];

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    changelog = "https://github.com/hvac/hvac/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
