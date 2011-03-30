{stdenv, fetchurl, unzip, ogre, cmake, ois, freetype, libuuid, boost}:

stdenv.mkDerivation rec {
  name = "mygui-3.0.1";
  
  src = fetchurl {
    url = mirror://sourceforge/my-gui/MyGUI_3.0.1_source.zip;
    sha256 = "1n56kl8ykzgv4k2nm9317jg9b9x2qa3l9hamz11hzn1qqjn2z4ig";
  };

  enableParallelBuilding = true;

  buildInputs = [ unzip ogre cmake ois freetype libuuid boost ];

  meta = {
    homepage = http://mygui.info/;
    description = "Library for creating GUIs for games and 3D applications";
    license = "LGPLv3+";
  };
}
