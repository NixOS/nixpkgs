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
<<<<<<< HEAD
  version = "3.4.2";
=======
  version = "3.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI${version}";
<<<<<<< HEAD
    hash = "sha256-yBV0ImOFJlqBPqqOjXYe4SFO2liSGZCEwvehED5Ubj4=";
=======
    hash = "sha256-5u9whibYKPj8tCuhdLOhL4nDisbFAB0NxxdjU/8izb8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
