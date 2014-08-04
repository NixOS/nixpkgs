{stdenv, fetchsvn, unzip, ogre, cmake, ois, freetype, libuuid, boost}:

stdenv.mkDerivation rec {
  name = "mygui-svn-4141";
  
  src = fetchsvn {
    url = https://my-gui.svn.sourceforge.net/svnroot/my-gui/trunk;
    rev = 4141;
    sha256 = "0xfm4b16ksqd1cwq45kl01wi4pmj244dpn11xln8ns7wz0sffjwn";
  };

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DOGRE_LIB_DIR=${ogre}/lib"
    "-DOGRE_INCLUDE_DIR=${ogre}/include/OGRE"
    "-DOGRE_LIBRARIES=OgreMain"
  ];

  buildInputs = [ unzip ogre cmake ois freetype libuuid boost ];

  meta = {
    homepage = http://mygui.info/;
    description = "Library for creating GUIs for games and 3D applications";
    license = stdenv.lib.licenses.lgpl3Plus;
  };
}
