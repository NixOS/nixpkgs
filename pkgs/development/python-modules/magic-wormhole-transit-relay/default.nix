{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  autobahn,
  twisted,
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole-transit-relay";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kS2DXaIbESZsdxEdybXlgAJj/AuY8KF5liJn30GBnow=";
  };

  patches = [
    # TODO: drop when updating beyond version 0.4.0
    (fetchpatch {
      name = "stock-Twisted-testing-reactor-seems-to-work.patch";
      url = "https://github.com/magic-wormhole/magic-wormhole-transit-relay/commit/3abb80fd5e55bd0ba8ee66278ccf76be5f904622.patch";
      hash = "sha256-qMaJ58kPWvEfnSZiFzxO6GlkBiyVMsgGDEa1deITZco=";
    })
  ];

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
