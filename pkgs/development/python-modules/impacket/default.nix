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
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uOsCCiy7RxRmac/jHGS7Ln1kmdBJxJPWQYuXFvXHRYM=";
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
