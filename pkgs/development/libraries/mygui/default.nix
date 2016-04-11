{  stdenv, fetchFromGitHub, libX11, unzip, cmake, ois, freetype, libuuid,
   boost, pkgconfig, withOgre ? true, ogre ? null, mesa ? null } :

let
  renderSystem = if withOgre then "3" else "4";
in stdenv.mkDerivation rec {
  name = "mygui-${version}";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
    sha256 = "1wk7jmwm55rhlqqcyvqsxdmwvl70bysl9azh4kd9n57qlmgk3zmw";
  };

  enableParallelBuilding = true;

  buildInputs = [ libX11 unzip cmake ois freetype libuuid boost pkgconfig (if withOgre then ogre else mesa) ];

  # Tools are disabled due to compilation failures.
  cmakeFlags = [ "-DMYGUI_BUILD_TOOLS=OFF" "-DMYGUI_BUILD_DEMOS=OFF" "-DMYGUI_RENDERSYSTEM=${renderSystem}" ];

  meta = with stdenv.lib; {
    homepage = http://mygui.info/;
    description = "Library for creating GUIs for games and 3D applications";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
