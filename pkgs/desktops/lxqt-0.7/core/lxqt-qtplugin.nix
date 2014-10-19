{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-qtplugin";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "f1bcaeb9ecfdf179d104441159f25da8eed16415";
    sha256 = "ece1ee19cbc666774bd90cf4ba035d2720677f66252ae5349fcd73c6c4d11f6e";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    liblxqt
  ];

  preConfigure = ''cmakeFlags="-DQT_PLUGINS_DIR=$out/lib/qt4/plugins"'';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "LxQt platform integration plugin for Qt 4 (let all Qt programs apply LxQt settings)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
