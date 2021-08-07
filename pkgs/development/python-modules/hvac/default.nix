{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
, six
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.10.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DGFvKdZkKtqrzUCKBEaTdO2DvhKyRQG7M36PN7rf7yI=";
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
