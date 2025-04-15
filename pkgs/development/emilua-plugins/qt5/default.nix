{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitLab,
  gperf,
  gawk,
  gitUpdater,
  pkg-config,
  boost,
  luajit_openresty,
  asciidoctor,
  libsForQt5,
  emilua,
  liburing,
  fmt,
  runCommand,
  xvfb-run,
  qt5, # this
}:

stdenv.mkDerivation rec {
  pname = "emilua-qt5";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "qt5";
    rev = "v${version}";
    hash = "sha256-9w9E0RWwW3scbmOOXdOXj22LR65a6XBHDkC8eimAfUs=";
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

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.basic =
      runCommand "test-basic-qt5"
        {
          buildInputs = [
            emilua
            qt5
            libsForQt5.wrapQtAppsHook
            xvfb-run
          ];
          dontWrapQtApps = true;
        }
        ''
          makeWrapper ${lib.getExe emilua} payload \
            ''${qtWrapperArgs[@]} \
            --add-flags ${./basic_test.lua}
          xvfb-run ./payload
          touch $out
        '';
  };

  meta = with lib; {
    description = "Qt5 bindings for Emilua";
    homepage = "https://emilua.org/";
    license = licenses.boost;
    maintainers = with maintainers; [
      manipuladordedados
      lucasew
    ];
    platforms = platforms.linux;
  };
}
