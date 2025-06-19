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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wlr-which-key";
    rev = "v${version}";
    hash = "sha256-P7DtSTyAfgACEfpnxYXhQ+Rvdw4rg2hFllCN1mEGfJQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yH05tpJiEDP0qEhDY3dpf2cxYeJYVOvOQyfcgg2vPQk=";

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
