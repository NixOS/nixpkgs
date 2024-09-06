{
  lib,
  stdenv,
  fetchFromGitLab,
  asciidoctor,
  ninja,
  gperf,
  gawk,
  pkg-config,
  boost,
  luajit_openresty,
  fmt,
  meson,
  emilua,
  qt6,
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

  buildInputs = [
    boost
    luajit_openresty
    emilua
    fmt
    openssl
    liburing
    qt6.qtdeclarative
    qt6.qtbase
  ];

  nativeBuildInputs = [
    gperf
    gawk
    asciidoctor
    pkg-config
    meson
    ninja
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  meta = with lib; {
    description = "Qt6 bindings for Emilua";
    homepage = "https://emilua.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
