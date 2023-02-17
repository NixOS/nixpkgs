{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, urllib3
, pyopenssl
, cryptography
, idna
, certifi
}:

buildPythonPackage rec {
  pname = "domeneshop";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kL0X1mEsmVWqnq5NgsMBxeAu48zjmi3muhZYryTCOMo=";
  };

  propagatedBuildInputs = [
    certifi
    urllib3
  ];

  # There are none
  doCheck = false;

  pythonImportsCheck = [ "domeneshop" ];

  meta = with lib; {
    description = "Python library for working with the Domeneshop API";
    homepage = "https://api.domeneshop.no/docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
