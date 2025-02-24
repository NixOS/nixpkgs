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
  qt6Packages,
  openssl,
  liburing,
  gitUpdater,
  runCommand,
  xvfb-run,
  qt6, # this
}:

stdenv.mkDerivation rec {
  pname = "emilua-qt6";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "qt6";
    rev = "v${version}";
    hash = "sha256-tSVJTEPLQ5z1OPtyNiu71AZcVmgzD7oWhDI8ccctGOQ=";
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

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.basic =
      runCommand "test-basic-qt6"
        {
          buildInputs = [
            emilua
            qt6
            qt6Packages.wrapQtAppsHook
            qt6Packages.qtbase
            qt6Packages.qtdeclarative
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
    description = "Qt6 bindings for Emilua";
    homepage = "https://emilua.org/";
    license = licenses.boost;
    maintainers = with maintainers; [
      manipuladordedados
      lucasew
    ];
    platforms = platforms.linux;
  };
}
