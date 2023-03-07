{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
, six
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-B53KWIVt7mZG7VovIoOAnBbS3u3eHp6WFbKRAySkuWk=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
