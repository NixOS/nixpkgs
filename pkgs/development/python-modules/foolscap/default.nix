{ lib
, buildPythonPackage
, fetchPypi
, mock
, pyopenssl
, pytestCheckHook
, service-identity
, twisted
}:

buildPythonPackage rec {
  pname = "foolscap";
  version = "21.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6dGFU4YNk1joXXZi2c2L84JtUbTs1ICgXfv0/EU2P4Q=";
  };

  propagatedBuildInputs = [
    mock
    twisted
    pyopenssl
    service-identity
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Not all dependencies are present
    "src/foolscap/test/test_connection.py"
  ];

  pythonImportsCheck = [ "foolscap" ];

  meta = with lib; {
    description = "RPC protocol for Python that follows the distributed object-capability model";
    longDescription = ''
      "Foolscap" is the name for the next-generation RPC protocol, intended to
      replace Perspective Broker (part of Twisted). Foolscap is a protocol to
      implement a distributed object-capabilities model in Python.
    '';
    homepage = "https://github.com/warner/foolscap";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
