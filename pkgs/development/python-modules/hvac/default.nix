{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
, six
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f905c59d32d88d3f67571fe5a8a78de4659e04798ad809de439f667247d13626";
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
