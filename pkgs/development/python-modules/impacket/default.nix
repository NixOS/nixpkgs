{ lib
, buildPythonPackage
, chardet
, fetchPypi
, flask
, ldapdomaindump
, pyasn1
, pycryptodomex
, pyopenssl
, pythonOlder
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GNVX04f0kU+vpzmBO5FyvD+L2cA26Tv1iajg67cwS7o=";
  };

  propagatedBuildInputs = [
    chardet
    flask
    ldapdomaindump
    pyasn1
    pycryptodomex
    pyopenssl
    setuptools
    six
  ];

  # RecursionError: maximum recursion depth exceeded
  doCheck = false;

  pythonImportsCheck = [
    "impacket"
  ];

  meta = with lib; {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/SecureAuthCorp/impacket";
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
