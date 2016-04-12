{  stdenv, fetchFromGitHub, libX11, unzip, cmake, ois, freetype, libuuid,
   boost, pkgconfig, lib, withOgre ? true, ogre ? null } :

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


  buildInputs = [ libX11 unzip cmake ois freetype libuuid boost pkgconfig ]
                ++ lib.optional withOgre [ ogre ];

  cmakeFlags = lib.optional (! withOgre) ["-DMYGUI_RENDERSYSTEM=1" "-DMYGUI_BUILD_DEMOS=OFF" "-DMYGUI_BUILD_TOOLS=OFF" "-DMYGUI_BUILD_PLUGINS=OFF"];

  meta = {
    homepage = http://mygui.info/;
    description = "Library for creating GUIs for games and 3D applications";
    license = stdenv.lib.licenses.lgpl3Plus;
  };
}
