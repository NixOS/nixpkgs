{ lib
, stdenv
, fetchFromGitHub
, qmake
, qtbase
, qtquick1
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
    qtquick1
    qtmultimedia
  ] ++ lib.optional stdenv.isDarwin utmp;

  patches = [
    # Some files are copied twice to the output which makes the build fails
    ./do-not-copy-artifacts-twice.patch
  ];

  postPatch = ''
    substituteInPlace qmltermwidget.pro \
      --replace '$$[QT_INSTALL_QML]' '$$PREFIX/${qtbase.qtQmlPrefix}/'
  '';

  dontWrapQtApps = true;

  meta = {
    description = "A QML port of qtermwidget";
    homepage = "https://github.com/Swordfish90/qmltermwidget";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
