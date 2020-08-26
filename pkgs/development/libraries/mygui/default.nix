{  stdenv, fetchFromGitHub, libX11, unzip, cmake, ois, freetype, libuuid,
   boost, pkgconfig, withOgre ? false, ogre ? null, libGL, libGLU ? null } :

let
  renderSystem = if withOgre then "3" else "4";
in stdenv.mkDerivation rec {
  pname = "mygui";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
    sha256 = "0a4zi8w18pjj813n7kmxldl1d9r1jp0iyhkw7pbqgl8f7qaq994w";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 unzip cmake ois freetype libuuid boost ]
    ++ (if withOgre then [ ogre ] else [libGL libGLU]);

  # Tools are disabled due to compilation failures.
  cmakeFlags = [ "-DMYGUI_BUILD_TOOLS=OFF" "-DMYGUI_BUILD_DEMOS=OFF" "-DMYGUI_RENDERSYSTEM=${renderSystem}" ];

  meta = with stdenv.lib; {
    homepage = "http://mygui.info/";
    description = "Library for creating GUIs for games and 3D applications";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
