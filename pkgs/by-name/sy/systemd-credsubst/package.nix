{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "systemd-credsubst";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "yaxitech";
    repo = "systemd-credsubst";
    tag = "v${version}";
    hash = "sha256-3KbO93OWJuiV8oYLSlqaj0i2x/2GwGxfQ7QwwSrfb1Y=";
  };
  cargoHash = "sha256-B2TxFgq/8z0KyL2soFwz/OqFVOVMNP7bamOXg0MuSK8=";
  meta = {
    description = "envsubst for systemd credentials";
    longDescription = "Substitute systemd credential references from ExecStart=/ExecStartPre= calls";
    homepage = "https://github.com/yaxitech/systemd-credsubst";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "systemd-credsubst";
    maintainers = [ lib.maintainers.veehaitch ];
  };
}
