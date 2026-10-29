{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-plugin-dds";
  version = "1.10.2"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-dds";
    tag = finalAttrs.version;
    hash = "sha256-awylJ8kxxkj3famRxEF4kz27YuShSPR4jvpKGgwX3KI=";
  };

  cargoHash = "sha256-25K8HEy8dtvyaGMZomt9mk4ygGcJbJoXKem74a5LMlk=";

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
