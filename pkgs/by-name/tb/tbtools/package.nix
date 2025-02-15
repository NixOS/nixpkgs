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

  useFetchCargoVendor = true;
  cargoHash = "sha256-SAHIDjELm4qr4whoQVdt3EuNA72qFqXEg3H0hYr7yLc=";

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
