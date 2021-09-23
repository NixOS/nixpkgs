{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
, six
}:

buildPythonPackage rec {
  pname = "hvac";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a734748a0c2f240655a5d50fb00162ccdbd674a17dd632c1efe2ca986487560";
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
