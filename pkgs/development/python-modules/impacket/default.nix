{ lib
, buildPythonPackage
, charset-normalizer
, dsinternals
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
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7kA5tNKu3o9fZEeLxZ+qyGA2eWviTeqNwY8An7CQXko=";
  };

  propagatedBuildInputs = [
    charset-normalizer
    dsinternals
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
    changelog = "https://github.com/fortra/impacket/releases/tag/impacket_"
      + replaceStrings [ "." ] [ "_" ] version;
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ fab ];
  };
}
