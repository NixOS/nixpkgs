{
  lib,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-improv-ble-client";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "py-improv-ble-client";
    tag = version;
    hash = "sha256-PkAZhKgj+xQtOOCccBXbR2QkwlkYavJe1pfU9nMhuVs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=65.6,<81.0" "setuptools" \
      --replace-fail "wheel>=0.37.1,<0.46.0" "wheel"
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
    changelog = "https://github.com/home-assistant-libs/py-improv-ble-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
