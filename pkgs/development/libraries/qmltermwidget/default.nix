{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qmake
, qtbase
, qtmultimedia
, utmp
}:

stdenv.mkDerivation {
  pname = "qmltermwidget";
  version = "unstable-2022-01-09";

  src = fetchFromGitHub {
    owner = "Swordfish90";
    repo = "qmltermwidget";
    rev = "63228027e1f97c24abb907550b22ee91836929c5";
    hash = "sha256-aVaiRpkYvuyomdkQYAgjIfi6a3wG2a6hNH1CfkA2WKQ=";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
    qtmultimedia
  ] ++ lib.optional stdenv.hostPlatform.isDarwin utmp;

  patches = [
    # Changes required to make it compatible with lomiri-terminal-app
    # QML-exposed colorscheme, scrollbar & clipboard functionality
    # Remove when https://github.com/Swordfish90/qmltermwidget/pull/39 merged
    (fetchpatch {
      name = "0001-qmltermwidget-lomiri-submissions.patch";
      url = "https://github.com/Swordfish90/qmltermwidget/compare/63228027e1f97c24abb907550b22ee91836929c5..ffc6b2b2a20ca785f93300eca93c25c4b74ece17.patch";
      hash = "sha256-1GjC2mdfP3NpePDWZaT8zvIq3vwWIZs+iQ9o01iQtD4=";
    })

    # A fix to the above series of patches, to fix a crash in lomiri-terminal-app
    # Remove (and update the above fetchpatch) when https://github.com/gber/qmltermwidget/pull/1 merged
    (fetchpatch {
      name = "0002-qmltermwidget-Mark-ColorSchemeManager-singleton-as-C++-owned.patch";
      url = "https://github.com/gber/qmltermwidget/commit/f3050bda066575eebdcff70fc1c3a393799e1d6d.patch";
      hash = "sha256-O8fEpVLYMze6q4ps7RDGbNukRmZZBjLwqmvRqpp+H+Y=";
    })

    # Some files are copied twice to the output which makes the build fails
    ./do-not-copy-artifacts-twice.patch
  ];

  postPatch = ''
    substituteInPlace qmltermwidget.pro \
      --replace '$$[QT_INSTALL_QML]' '$$PREFIX/${qtbase.qtQmlPrefix}/'
  '';

  dontWrapQtApps = true;

  meta = {
    description = "QML port of qtermwidget";
    homepage = "https://github.com/Swordfish90/qmltermwidget";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
