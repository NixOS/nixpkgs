{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, freetype
, withOgre ? false
, withTools ? false
, ogre
, libGL
, libGLU
, Cocoa
, SDL2
, SDL2_image
, zlib
}:

let
  renderSystem = if withOgre then "3" else "4";
in
stdenv.mkDerivation rec {
  pname = "mygui";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
    hash = "sha256-qif9trHgtWpYiDVXY3cjRsXypjjjgStX8tSWCnXhXlk=";
  };

  patches = [
    ./disable-framework.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    freetype
    zlib
  ] ++ lib.optionals withOgre [
    ogre
    boost
  ] ++ lib.optionals (!withOgre && stdenv.isLinux) [
    libGL
    libGLU
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  cmakeFlags = [
    "-DMYGUI_BUILD_TOOLS=${if withTools then "ON" else "OFF"}"
    "-DMYGUI_BUILD_DEMOS=OFF"
    "-DMYGUI_INSTALL_TOOLS=${if withTools then "ON" else "OFF"}"
    "-DMYGUI_RENDERSYSTEM=${renderSystem}"
  ];

  meta = with lib; {
    homepage = "http://mygui.info/";
    description = "Library for creating GUIs for games and 3D applications";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
