{
  buildPythonPackage,
  fetchPypi,
  lib,
  mock,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
  twisted,
  txi2p-tahoe,
  txtorcon,
  versioneer,
}:

buildPythonPackage rec {
  pname = "foolscap";
  version = "23.3.0";

  pyproject = true;
  build-system = [
    setuptools
    versioneer
  ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vu7oXC1brsgBwr2q59TAgx8j1AFRbi5mjRNIWZTbkUU=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  dependencies = [
    six
    twisted
    pyopenssl
  ] ++ twisted.optional-dependencies.tls;

  passthru.optional-dependencies = {
    i2p = [ txi2p-tahoe ];
    tor = [ txtorcon ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

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
