{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitLab,
  gperf,
  gawk,
  pkg-config,
  boost,
  luajit_openresty,
  asciidoctor,
  libsForQt5,
  emilua,
  liburing,
  fmt,
}:

stdenv.mkDerivation rec {
  pname = "emilua-qt5";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "qt5";
    rev = "v${version}";
    hash = "sha256-FkBfzGzUX7dvHjWRBjVwppU4jZBbY02gP+fIta8mjIw=";
  };

  buildInputs = [
    luajit_openresty
    boost
    libsForQt5.qtdeclarative
    emilua
    liburing
    fmt
    libsForQt5.qtbase
  ];

  nativeBuildInputs = [
    gperf
    gawk
    pkg-config
    asciidoctor
    meson
    ninja
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  meta = with lib; {
    description = "Qt5 bindings for Emilua";
    homepage = "https://emilua.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.linux;
  };
}
