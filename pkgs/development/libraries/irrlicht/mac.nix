{
  lib,
  stdenv,
  fetchzip,
  libGLU,
  libGL,
  fetchFromGitHub,
  cmake,
  Cocoa,
  OpenGL,
  IOKit,
}:

let
  common = import ./common.nix { inherit fetchzip; };
in

stdenv.mkDerivation rec {
  pname = "irrlicht-mac";
  version = common.version;

  src = fetchFromGitHub {
    owner = "quiark";
    repo = "IrrlichtCMake";
    rev = "523a5e6ef84be67c3014f7b822b97acfced536ce";
    sha256 = "10ahnry2zl64wphs233gxhvs6c0345pyf5nwa29mc6yn49x7bidi";
  };

  postUnpack = ''
    cp -r ${common.src}/* $sourceRoot/
    chmod -R 777 $sourceRoot
  '';

  patches = [ ./mac_device.patch ];
  dontFixCmake = true;

  cmakeFlags = [
    "-DIRRLICHT_STATIC_LIBRARY=ON"
    "-DIRRLICHT_BUILD_EXAMPLES=OFF"
    "-DIRRLICHT_INSTALL_MEDIA_FILES=OFF"
    "-DIRRLICHT_ENABLE_X11_SUPPORT=OFF"
    "-DIRRLICHT_BUILD_TOOLS=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    OpenGL
    Cocoa
    IOKit
  ];

  meta = {
    homepage = "https://irrlicht.sourceforge.net/";
    license = lib.licenses.zlib;
    description = "Open source high performance realtime 3D engine written in C++";
    platforms = lib.platforms.darwin;
  };
}
