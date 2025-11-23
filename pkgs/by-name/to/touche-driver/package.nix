{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  systemd,
}:
rustPlatform.buildRustPackage rec {
  pname = "touche-driver";
  version = "0.1.2";

  useFetchCargoVendor = true;

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ systemd ];

  src = fetchFromGitHub {
    owner = "bpavuk";
    repo = "touche-driver";
    tag = "v${version}";
    hash = "sha256-n/GL/xpgaGRng9q7dY/gL+bgGka8u2qdNaxi4vyhLjU=";
  };

  cargoHash = "sha256-0vdPueFl273Y5FkXRn4vFzvY9RO+di5Mbga7z68iepU=";

  meta = {
    description = "Turn your phone into a touchpad + graphics tablet with reaction of a fencer";
    homepage = "https://github.com/bpavuk/touche-driver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bpavuk
    ];
    mainProgram = "touche-driver";
    platforms = lib.platforms.linux;
  };
}
