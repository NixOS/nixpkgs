{ lib, stdenv, fetchzip, libGLU, libGL, libXrandr, libX11, libXxf86vm }:

let
  common = import ./common.nix { inherit fetchzip; };
in

stdenv.mkDerivation rec {
  pname = common.pname;
  version = common.version;

  src = common.src;

  postPatch = ''
    sed -ie '/sys\/sysctl.h/d' source/Irrlicht/COSOperator.cpp
  '';

  preConfigure = ''
    cd source/Irrlicht
  '';

  buildPhase = ''
    make sharedlib NDEBUG=1 "LDFLAGS=-lX11 -lGL -lXxf86vm"
  '';

  preInstall = ''
    sed -i s,/usr/local/lib,$out/lib, Makefile
    mkdir -p $out/lib
  '';

  buildInputs = [ libGLU libGL libXrandr libX11 libXxf86vm ];

  meta = {
    homepage = "http://irrlicht.sourceforge.net/";
    license = lib.licenses.zlib;
    description = "Open source high performance realtime 3D engine written in C++";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
