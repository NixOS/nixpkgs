{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, freetype
, libuuid
, ois
, withOgre ? false
, ogre
, libGL
, libGLU
, libX11
, Cocoa
}:

let
  renderSystem = if withOgre then "3" else "4";
in
stdenv.mkDerivation rec {
  pname = "mygui";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
    sha256 = "0a4zi8w18pjj813n7kmxldl1d9r1jp0iyhkw7pbqgl8f7qaq994w";
  };

  patches = [
    ./disable-framework.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    freetype
    libuuid
    ois
  ] ++ lib.optionals withOgre [
    ogre
  ] ++ lib.optionals (!withOgre && stdenv.isLinux) [
    libGL
    libGLU
  ] ++ lib.optionals stdenv.isLinux [
    libX11
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  # Tools are disabled due to compilation failures.
  cmakeFlags = [
    "-DMYGUI_BUILD_TOOLS=OFF"
    "-DMYGUI_BUILD_DEMOS=OFF"
    "-DMYGUI_RENDERSYSTEM=${renderSystem}"
  ];

  meta = with lib; {
    homepage = "http://mygui.info/";
    description = "Library for creating GUIs for games and 3D applications";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
