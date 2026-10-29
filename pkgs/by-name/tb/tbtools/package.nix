{
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenv,
  systemd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tbtools";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tbtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tDAaWFMZeJcU2wzrOD/4DLHerm/Iy56HTe5Qz98I23M=";
  };

  cargoHash = "sha256-94O+ma6twGfXr/QM7nZRmNVV4s4Z2YnsYNsNELjnhiQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Thunderbolt/USB4 debugging tools";
    homepage = "https://github.com/intel/tbtools";
    license = lib.licenses.mit;
    mainProgram = "tblist";
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    platforms = lib.platforms.linux;
  };
})
