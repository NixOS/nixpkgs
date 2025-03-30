{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  brotli,
  certifi,
  grpcio,
  protobuf,
}:
buildPythonPackage rec {
  pname = "netbox-diode-plugin";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "diode-netbox-plugin";
    rev = "v${version}";
    hash = "sha256-VamAjgPUwU2N69r4cFZkg3f6bY4LMXk/4IE85/27n/U=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  dependencies = [
    brotli
    certifi
    grpcio
    protobuf
  ];

  postPatch = ''
    sed -i -E 's/(certifi|grpcio|protobuf)==[0-9\.]*/\1/' pyproject.toml
  '';

  pythonImportsCheck = [ "netbox_diode_plugin" ];

  meta = {
    description = "Official NetBox Labs plugin for NetBox for Diode";
    homepage = "https://github.com/netboxlabs/diode-netbox-plugin";
    changelog = "https://github.com/netboxlabs/diode-netbox-plugin/releases/tag/${src.rev}";
    license = lib.licenses.polyFormShield;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
