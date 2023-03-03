{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
, six
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5AKMXA7Me3/PalTSkPmSQOWrzbn/5ELRwU8GExDUxhw=";
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
