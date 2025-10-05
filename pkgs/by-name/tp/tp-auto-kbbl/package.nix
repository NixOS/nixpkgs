{
  lib,
  fetchFromGitHub,
  rustPlatform,
  dbus,
  pkg-config,
  openssl,
  libevdev,
}:

rustPlatform.buildRustPackage rec {
  pname = "tp-auto-kbbl";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "saibotd";
    repo = "tp-auto-kbbl";
    rev = version;
    hash = "sha256-fhBCsOjaQH2tRsBjMGiDmZSIkAgEVxxywVp8/0uAaTU=";
  };

  cargoHash = "sha256-Ptc4m+99YknHY28DR5WHt/JG9tgUOcbz/TezUkezmS8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libevdev
    openssl
  ];

  meta = with lib; {
    description = "Auto toggle keyboard back-lighting on Thinkpads (and maybe other laptops) for Linux";
    homepage = "https://github.com/saibotd/tp-auto-kbbl";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "tp-auto-kbbl";
  };
}
