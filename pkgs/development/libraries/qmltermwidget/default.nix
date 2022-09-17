{ lib, stdenv, fetchFromGitHub, qtbase, qtquick1, qmake, qtmultimedia, utmp }:

stdenv.mkDerivation {
  pname = "qmltermwidget-unstable";
  version = "unstable-2022-09-16";

  src = fetchFromGitHub {
    repo = "qmltermwidget";
    owner = "Swordfish90";
    rev = "63228027e1f97c24abb907550b22ee91836929c5";
    sha256 = "aVaiRpkYvuyomdkQYAgjIfi6a3wG2a6hNH1CfkA2WKQ=";
  };

  buildInputs = [ qtbase qtquick1 qtmultimedia ]
                ++ lib.optional stdenv.isDarwin utmp;
  nativeBuildInputs = [ qmake ];

  postPatch = ''
    substituteInPlace qmltermwidget.pro \
      --replace '$$[QT_INSTALL_QML]' "/$qtQmlPrefix/"
  '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  dontWrapQtApps = true;

  meta = {
    description = "A QML port of qtermwidget";
    homepage = "https://github.com/Swordfish90/qmltermwidget";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ skeidel ];
  };
}
