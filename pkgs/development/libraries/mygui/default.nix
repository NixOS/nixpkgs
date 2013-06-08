{stdenv, fetchurl, unzip, ogre, cmake, ois, freetype, libuuid, boost, pkgconfig}:

stdenv.mkDerivation rec {
  name = "mygui-3.2.0";
  
  src = fetchurl {
    url = mirror://sourceforge/my-gui/MyGUI_3.2.0.zip;
    sha256 = "16m1xrhx13qbwnp9gds2amlwycq8q5npr0665hnknwsb6rph010p";
  };

  enableParallelBuilding = true;

  buildInputs = [ unzip ogre cmake ois freetype libuuid boost pkgconfig ];

  meta = {
    homepage = http://mygui.info/;
    description = "Library for creating GUIs for games and 3D applications";
    license = "LGPLv3+";
  };
}
