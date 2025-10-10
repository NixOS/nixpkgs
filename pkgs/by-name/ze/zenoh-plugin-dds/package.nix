{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-dds";
  version = "1.4.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-dds";
    rev = version;
    hash = "sha256-vSFgxSSbLEwpwPznvy+m66Z5grgmxZiIom/I4p0xris=";
  };

  cargoHash = "sha256-oMmO4N1EqqpWcujbm8sPPwEzNC1Gy2UdCCRqcgyQqdI=";

  nativeBuildInputs = [
    cmake
    rustPlatform.bindgenHook
  ];

  # Some test time out
  doCheck = false;

  meta = {
    description = "Zenoh plugin for DDS";
    longDescription = "A zenoh plug-in that allows to transparently route DDS data. This plugin can be used by DDS applications to leverage zenoh for geographical routing or for better scaling discovery";
    homepage = "https://github.com/eclipse-zenoh/zenoh-plugin-dds";
    changelog = "https://github.com/eclipse-zenoh/zenoh-plugin-dds/releases/tag/${src.rev}";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ kaweees ];
    platforms = lib.platforms.linux;
    mainProgram = "zenoh-bridge-dds";
  };
}
