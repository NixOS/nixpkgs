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
  version = "24.9.0";

  pyproject = true;
  build-system = [
    setuptools
    versioneer
  ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vWsAdUDbWQuG3e0oAtLq8rA4Ys2wg38fD/h+E1ViQQg=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  dependencies = [
    six
    twisted
    pyopenssl
  ]
  ++ twisted.optional-dependencies.tls;

  optional-dependencies = {
    i2p = [ txi2p-tahoe ];
    tor = [ txtorcon ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

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
    maintainers = [ ];
  };
}
