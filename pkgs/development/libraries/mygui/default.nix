{  lib, stdenv, fetchFromGitHub, libX11, cmake, ois, freetype, libuuid,
   boost, pkg-config, withOgre ? false, ogre ? null, libGL, libGLU ? null } :

let
  renderSystem = if withOgre then "3" else "4";
in stdenv.mkDerivation rec {
  pname = "mygui";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
    sha256 = "sha256-5u9whibYKPj8tCuhdLOhL4nDisbFAB0NxxdjU/8izb8=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libX11 ois freetype libuuid boost ]
    ++ (if withOgre then [ ogre ] else [ libGL libGLU ]);

  # Tools are disabled due to compilation failures.
  cmakeFlags = [ "-DMYGUI_BUILD_TOOLS=OFF" "-DMYGUI_BUILD_DEMOS=OFF" "-DMYGUI_RENDERSYSTEM=${renderSystem}" ];

  meta = with lib; {
    homepage = "http://mygui.info/";
    description = "Library for creating GUIs for games and 3D applications";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
