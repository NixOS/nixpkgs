{ stdenv, fetchgit, qt5 }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  name = "qmltermwidget-${version}";

  src = fetchgit {
    url = "https://github.com/Swordfish90/qmltermwidget.git";
    rev = "refs/tags/v${version}";
    sha256 = "19pz27jsdpa3pybj8sghmmd1zqgr73js1mp3875rhx158dav37nz";
  };

  buildInputs = [ qt5 ];

  patchPhase = ''
    substituteInPlace qmltermwidget.pro \
      --replace '$$[QT_INSTALL_QML]' "/lib/qml/"
  '';

  configurePhase = "qmake PREFIX=$out";

  installPhase=''make INSTALL_ROOT="$out" install'';
  
  enableParallelBuilding = true;

  meta = {
    description = "This project is a QML port of qtermwidget";
    homepage = "https://github.com/Swordifish90/qmltermwidget";
    license = with stdenv.lib.licenses; [ gpl2 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}
