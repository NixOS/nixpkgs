{
  lib,
  stdenv,
  fetchFromGitLab,
  asciidoctor,
  ninja,
  gperf,
  gawk,
  pkg-config,
  cmake,
  boost,
  luajit_openresty,
  fmt,
  meson,
  emilua,
  qt6Packages,
  openssl,
  liburing,
}:

stdenv.mkDerivation rec {
  pname = "emilua-qt6";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "qt6";
    rev = "v${version}";
    hash = "sha256-azMnM17HQMzC0ExgWurQzbR3fX9EwBRSu4kVTm3U2Ic=";
  };

  buildInputs = with qt6Packages; [
    qtbase
    qtdeclarative
    boost
    luajit_openresty
    emilua
    fmt
    openssl
    liburing
  ];

  nativeBuildInputs = with qt6Packages; [
    qttools
    wrapQtAppsHook
    gperf
    gawk
    asciidoctor
    pkg-config
    meson
    ninja
  ];

  meta = with lib; {
    description = "Qt6 bindings for Emilua";
    homepage = "https://emilua.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
