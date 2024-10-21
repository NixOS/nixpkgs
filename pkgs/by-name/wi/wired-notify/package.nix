{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  pango,
  cairo,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "wired-notify";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Toqozz";
    repo = pname;
    rev = version;
    hash = "sha256-AWIV/+vVwDZECZ4lFMSFyuyUKJc/gb72PiBJv6lbhnc=";
  };

  cargoHash = "sha256-zTTXVjXRQ6zgm1+nLkRitm2WlvJZDDd9WF1dAAGseYo=";

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    pango
    cairo
    xorg.libXScrnSaver
    xorg.libXcursor
    xorg.libXrandr
    xorg.libX11
    xorg.libXi
  ];

  meta = with lib; {
    description = "Lightweight notification daemon written in Rust";
    homepage = "https://github.com/Toqozz/wired-notify";
    license = licenses.mit;
    maintainers = with maintainers; [ fccapria ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
    mainProgram = "wired";
  };
}
