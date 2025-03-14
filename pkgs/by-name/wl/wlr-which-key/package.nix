{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cairo,
  glib,
  libxkbcommon,
  pango,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlr-which-key";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wlr-which-key";
    rev = "v${version}";
    hash = "sha256-BEf1qpy0bVPi5nmu3UUiv8k0bJvE5VFB5Zqb5lS0+t4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-409PW1Ya38imGqtrVqOI50yJa49/RjB68yGQZSvyYd0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    glib
    libxkbcommon
    pango
  ];

  meta = with lib; {
    description = "Keymap manager for wlroots-based compositors";
    homepage = "https://github.com/MaxVerevkin/wlr-which-key";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xlambein ];
    platforms = platforms.linux;
    mainProgram = "wlr-which-key";
  };
}
