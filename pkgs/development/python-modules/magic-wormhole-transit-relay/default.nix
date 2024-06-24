{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  autobahn,
  mock,
  twisted,
  pythonOlder,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole-transit-relay";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y0gBtGiQ6v+XKG4OP+xi0dUv/jF9FACDtjNqH7To+l4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    autobahn
    twisted
  ];

  pythonImportsCheck = [ "wormhole_transit_relay" ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    twisted
  ];

  meta = {
    description = "Transit Relay server for Magic-Wormhole";
    homepage = "https://github.com/magic-wormhole/magic-wormhole-transit-relay";
    changelog = "https://github.com/magic-wormhole/magic-wormhole-transit-relay/blob/${version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
  };
}
