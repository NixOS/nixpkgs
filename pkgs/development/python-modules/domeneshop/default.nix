{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, urllib3
, pyopenssl
, cryptography
, idna
, certifi
}:

buildPythonPackage rec {
  pname = "domeneshop";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kL0X1mEsmVWqnq5NgsMBxeAu48zjmi3muhZYryTCOMo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  dependencies = [
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
