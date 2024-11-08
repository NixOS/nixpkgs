{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  autobahn,
  mock,
  twisted,
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole-transit-relay";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LvLvvk008OYkhw+EIln9czuncVLtMQr0NJd0piiEkA4=";
  };

  postPatch = ''
    # Passing the environment to twistd is necessary to preserve Python's site path.
    substituteInPlace src/wormhole_transit_relay/test/test_backpressure.py --replace-fail \
      'reactor.spawnProcess(proto, exe, args)' \
      'reactor.spawnProcess(proto, exe, args, None)'
  '';

  build-system = [ setuptools ];

  dependencies = [
    autobahn
    setuptools # pkg_resources is referenced at runtime
    twisted
  ];

  pythonImportsCheck = [ "wormhole_transit_relay" ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    twisted
  ];

  __darwinAllowLocalNetworking = true;

  postCheck = ''
    # Avoid collision with twisted's plugin cache (#164775).
    rm "$out/${python.sitePackages}/twisted/plugins/dropin.cache"
  '';

  meta = {
    description = "Transit Relay server for Magic-Wormhole";
    homepage = "https://github.com/magic-wormhole/magic-wormhole-transit-relay";
    changelog = "https://github.com/magic-wormhole/magic-wormhole-transit-relay/blob/${version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
  };
}
