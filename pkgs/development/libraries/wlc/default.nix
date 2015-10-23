{ lib, stdenv, fetchurl, cmake, pkgconfig
, glibc, wayland, pixman, libxkbcommon, libinput, libxcb, xcbutilwm, xcbutilimage, mesa, libdrm, udev, systemd, dbus_libs
, libpthreadstubs, libX11, libXau, libXdmcp, libXext, libXdamage, libxshmfence, libXxf86vm, linuxPackages_4_2
}:

stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "git-2015-10-04";
  repo = "https://github.com/Cloudef/wlc";
  rev = "74d978cc54fd8256777c8d39327cb677523cddff";

  chck_repo = "https://github.com/Cloudef/chck";
  chck_rev = "6191a69572952291c137294317874c06c9c0d6a9";

  srcs = [
   (fetchurl {
     url = "${repo}/archive/${rev}.tar.gz";
     sha256 = "a3641e79252a140be089dd2e829b4d21a3b5ff10866951568d54bd4600597254";
   })
   (fetchurl {
     url = "${chck_repo}/archive/${chck_rev}.tar.gz";
     sha256 = "26b4af1390bf67c674732cad69fc94fb027a3d269241d0bd862f42fb80bd5160";
   })
  ];

  sourceRoot = "wlc-${rev}";
  postUnpack = ''
    rm -rf wlc-${rev}/lib/chck
    ln -s ../../chck-${chck_rev} wlc-${rev}/lib/chck
  '';

  patchPhase = ''
    ( echo '#include <stdlib.h>';
      echo '#include <libdrm/drm.h>';
      cat src/platform/backend/drm.c
    ) >src/platform/backend/drm.c-fix;
    mv src/platform/backend/drm.c-fix src/platform/backend/drm.c;
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wayland pixman libxkbcommon libinput libxcb xcbutilwm xcbutilimage mesa libdrm udev
    libpthreadstubs libX11 libXau libXdmcp libXext libXdamage libxshmfence libXxf86vm
    systemd dbus_libs
  ];

  makeFlags = "PREFIX=$(out) -lchck";
  installPhase = "PREFIX=$out make install";

  meta = {
    description = "A library for making a simple Wayland compositor";
    homepage    = repo;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
