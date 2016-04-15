{stdenv, fetchFromGitHub, libX11, unzip, ogre, cmake, ois, freetype, libuuid, boost, pkgconfig}:

stdenv.mkDerivation rec {
  name = "mygui-${version}";
  version = "3.2.2";
  
  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
    sha256 = "1wk7jmwm55rhlqqcyvqsxdmwvl70bysl9azh4kd9n57qlmgk3zmw";
  };

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-rpath-link ${boost.lib}/lib";

  buildInputs = [ libX11 unzip ogre cmake ois freetype libuuid boost pkgconfig ];

  meta = {
    homepage = http://mygui.info/;
    description = "Library for creating GUIs for games and 3D applications";
    license = stdenv.lib.licenses.lgpl3Plus;
  };
}
