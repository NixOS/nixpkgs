{
  lib,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-improv-ble-client";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "py-improv-ble-client";
    rev = "refs/tags/${version}";
    hash = "sha256-leYSDB5/jFqlvX78OYzlFkkVxIkJ7iOUoLHBuVj7tAo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=65.6" "setuptools" \
      --replace-fail "wheel~=0.37.1" "wheel"
  '';

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "improv_ble_client" ];

  meta = {
    description = "Module to provision devices which implement Improv via BLE";
    homepage = "https://github.com/home-assistant-libs/py-improv-ble-client";
    changelog = "https://github.com/home-assistant-libs/py-improv-ble-client/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
