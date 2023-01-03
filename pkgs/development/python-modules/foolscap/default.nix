{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "fix-tests-with-twisted-22.10.0.patch";
      url = "https://github.com/warner/foolscap/commit/c04202eb5d4cf052e650ec2985ea6037605fd79e.patch";
      hash = "sha256-RldDc18n3WYHdYg0ZmM8PBffIuiGa1NIfdoHs3mEEfc=";
    })
  ];

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
