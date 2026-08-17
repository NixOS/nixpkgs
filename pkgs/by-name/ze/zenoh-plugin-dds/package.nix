{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-plugin-dds";
  version = "1.10.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-dds";
    tag = finalAttrs.version;
    hash = "sha256-CPtIYxfiK/2Gs7yiXlzPUppDbd1R6cnbxZe/YIzX8fo=";
  };

  cargoHash = "sha256-nWk212kRNkz6YxW2pNed4PjKX2kJZlsaxm9KXUrh8/Q=";

  nativeBuildInputs = [
    cmake
    rustPlatform.bindgenHook
  ];

  checkFlags = [
    "--skip=test_name_that_times_out"
  ];

  meta = {
    description = "Zenoh plugin for DDS";
    longDescription = "A zenoh plug-in that allows to transparently route DDS data. This plugin can be used by DDS applications to leverage zenoh for geographical routing or for better scaling discovery";
    homepage = "https://github.com/eclipse-zenoh/zenoh-plugin-dds";
    changelog = "https://github.com/eclipse-zenoh/zenoh-plugin-dds/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ kaweees ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "zenoh-bridge-dds";
  };
})
