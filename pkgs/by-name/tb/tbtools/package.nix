{
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenv,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "tbtools";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tbtools";
    tag = "v${version}";
    hash = "sha256-zq8q3JaoqWAQUat2gIW0Wimi/tZiC6XDphUVjH0viU4=";
  };

  cargoHash = "sha256-8uzbWJl3Bpvo/rlZnd7DzCNhL088v5pksY7K6yncC1s=";

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
}
