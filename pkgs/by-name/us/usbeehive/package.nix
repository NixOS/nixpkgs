{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbeehive";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abrauchli";
    repo = "usbeehive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OQtAZnoQOQWlMY51JoaGDPHXjYtwHXu4cnzuEzcblWU=";
  };

  cargoHash = "sha256-wiIc7ofX57nL2931P/tIom3SibmuuFqShXG4r/FKzEA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  passthru.tests.dbus = rustPlatform.buildRustPackage {
    pname = "usbeehive-dbus-test";
    inherit (finalAttrs) version src cargoHash;

    cargoBuildNoDefaultFeatures = true;
    cargoBuildFeatures = [ "dbus" ];

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ udev ];

    doCheck = true;

  };

  meta = {
    description = "Inspect USB-C cables and devices on Linux";
    homepage = "https://github.com/abrauchli/usbeehive";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "usbeehive";
    maintainers = with lib.maintainers; [ mach ];
  };
})
