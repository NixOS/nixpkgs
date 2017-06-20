{ stdenv, fetchFromGitHub, qmake, qtwebkit, hunspell }:

stdenv.mkDerivation {
  name = "qtwebkit-plugins-2015-05-09";

  src = fetchFromGitHub {
    owner = "QupZilla";
    repo = "qtwebkit-plugins";
    rev = "4e2e0402abd847346bec704be5305ba849eb754b";
    sha256 = "0xyq25l56jgdxgqqv0380brhw9gg0hin5hyrf1j6d3c8k1gka20m";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtwebkit hunspell ];

  postPatch = ''
    sed -i "s,-lhunspell,-lhunspell-1.6," src/spellcheck/spellcheck.pri
    sed -i "s,\$\$\[QT_INSTALL_PLUGINS\],$out/$qtPluginPrefix," src/src.pro
  '';

  meta = with stdenv.lib; {
    description = "Spell checking plugin using Hunspell and HTML5 Notifications plugin for QtWebKit";
    homepage = "https://github.com/QupZilla/qtwebkit-plugins";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
