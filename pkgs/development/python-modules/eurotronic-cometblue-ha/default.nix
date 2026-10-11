{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  bleak,
  bleak-retry-connector,
}:

buildPythonPackage (finalAttrs: {
  pname = "eurotronic-cometblue-ha";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rikroe";
    repo = "eurotronic-cometblue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j3UuN0Cmb2mOo3QGqy0wu19+vRyMahclXKyka2Vy10w=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Tests require a real Bluetooth Comet Blue device.
  doCheck = false;

  pythonImportsCheck = [ "eurotronic_cometblue_ha" ];

  meta = {
    description = "Python client for Eurotronic GmbH BLE Comet (and rebranded) Radiator TRVs";
    homepage = "https://github.com/rikroe/eurotronic-cometblue";
    changelog = "https://github.com/rikroe/eurotronic-cometblue/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
