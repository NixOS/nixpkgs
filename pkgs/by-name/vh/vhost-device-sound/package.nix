{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  pipewire,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vhost-device-sound";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rust-vmm";
    repo = "vhost-device";
    tag = "vhost-device-sound-v${finalAttrs.version}";
    hash = "sha256-MJRjnJewT1kyy37QzjJ0OToEwdZMZkKxtbyGees/vYU=";
  };

  cargoHash = "sha256-PXJZouhPeylpqX/FLY7pmX+eV+IanRqHSwaJriXFhw8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    alsa-lib
    pipewire
  ];

  cargoBuildFlags = "-p vhost-device-sound";
  cargoTestFlags = "-p vhost-device-sound";

  # Runs dbus-daemon, which tries to load config from /etc.
  doCheck = false;

  meta = {
    homepage = "https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-sound";
    description = "virtio-sound device using the vhost-user protocol";
    license = [
      lib.licenses.asl20
      lib.licenses.bsd3
    ];
    maintainers = [ lib.maintainers.qyliss ];
    platforms = lib.platforms.unix;
  };
})
