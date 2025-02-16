{
  lib,
  stdenv,
  fetchzip,
  libGLU,
  libGL,
  libXrandr,
  libX11,
  libXxf86vm,
  zlib,
}:

let
  common = import ./common.nix { inherit fetchzip; };
in

stdenv.mkDerivation rec {
  pname = common.pname;
  version = common.version;

  src = common.src;

  postPatch =
    ''
      sed -ie '/sys\/sysctl.h/d' source/Irrlicht/COSOperator.cpp
    ''
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      substituteInPlace source/Irrlicht/Makefile \
        --replace "-DIRRLICHT_EXPORTS=1" "-DIRRLICHT_EXPORTS=1 -DPNG_ARM_NEON_OPT=0"
    '';

  preConfigure = ''
    cd source/Irrlicht
  '';

  preBuild = ''
    makeFlagsArray+=(sharedlib NDEBUG=1 LDFLAGS="-lX11 -lGL -lXxf86vm")
  '';

  enableParallelBuilding = true;

  preInstall = ''
    sed -i s,/usr/local/lib,$out/lib, Makefile
    mkdir -p $out/lib
  '';

  buildInputs = [
    libGLU
    libGL
    libXrandr
    libX11
    libXxf86vm
  ] ++ lib.optional stdenv.hostPlatform.isAarch64 zlib;

  meta = {
    homepage = "https://irrlicht.sourceforge.io/";
    license = lib.licenses.zlib;
    description = "Open source high performance realtime 3D engine written in C++";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
