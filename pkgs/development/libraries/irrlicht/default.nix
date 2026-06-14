{
  lib,
  stdenv,
  callPackage,
  fetchzip,
  libGLU,
  libGL,
  libxrandr,
  libx11,
  libxxf86vm,
  zlib,
}:

let
  version = "1.8.5";

  linuxSrc = fetchzip {
    url = "mirror://sourceforge/irrlicht/irrlicht-${version}.zip";
    hash = "sha256-cTkzxquMLl84/cSDZnSSQsmXRX/htV8M5NUTbnQuHoM=";
  };
in

if stdenv.hostPlatform.isDarwin then
  callPackage ./mac.nix {
    inherit version linuxSrc;
  }
else
  stdenv.mkDerivation (finalAttrs: {
    pname = "irrlicht";
    inherit version;

    src = linuxSrc;

    __structuredAttrs = true;
    strictDeps = true;

    postPatch = ''
      sed -i -e '/sys\/sysctl.h/d' source/Irrlicht/COSOperator.cpp
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
      libxrandr
      libx11
      libxxf86vm
    ]
    ++ lib.optional stdenv.hostPlatform.isAarch64 zlib;

    meta = {
      homepage = "https://irrlicht.sourceforge.io/";
      license = lib.licenses.zlib;
      description = "Open source high performance realtime 3D engine written in C++";
      platforms = lib.platforms.linux;
    };
  })
