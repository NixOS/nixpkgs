{
  lib,
  fetchFromGitHub,
  rustPlatform,
  dbus,
  pkg-config,
  openssl,
  libevdev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tp-auto-kbbl";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "saibotd";
    repo = "tp-auto-kbbl";
    rev = finalAttrs.version;
    hash = "sha256-fhBCsOjaQH2tRsBjMGiDmZSIkAgEVxxywVp8/0uAaTU=";
  };

  cargoHash = "sha256-Ptc4m+99YknHY28DR5WHt/JG9tgUOcbz/TezUkezmS8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libevdev
    openssl
  ];

  meta = {
    description = "Auto toggle keyboard back-lighting on Thinkpads (and maybe other laptops) for Linux";
    homepage = "https://github.com/saibotd/tp-auto-kbbl";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "tp-auto-kbbl";
  };
})
