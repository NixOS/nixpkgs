{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtwebkit,
  hunspell,
}:

stdenv.mkDerivation {
  pname = "qtwebkit-plugins";
  version = "unstable-2017-01-25";

  src = fetchFromGitHub {
    owner = "QupZilla";
    repo = "qtwebkit-plugins";
    rev = "b58ee9d5b31977491662aa4e8bee16404638bf14";
    sha256 = "04wvlhdj45g1v1a3zl0pkf9r72i22h1br10lhhrgad7ypym974gw";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtwebkit
    hunspell
  ];

  dontWrapQtApps = true;

  postPatch = ''
    sed -i "s,-lhunspell,-lhunspell-${lib.versions.majorMinor hunspell.version}," src/spellcheck/spellcheck.pri
    sed -i "s,\$\$\[QT_INSTALL_PLUGINS\],$out/$qtPluginPrefix," src/src.pro
  '';

  meta = with lib; {
    description = "Spell checking plugin using Hunspell and HTML5 Notifications plugin for QtWebKit";
    homepage = "https://github.com/QupZilla/qtwebkit-plugins";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
