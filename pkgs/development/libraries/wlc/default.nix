{ lib, stdenv, fetchurl, fetchgit, cmake, pkgconfig
, glibc, wayland, pixman, libxkbcommon, libinput, libxcb, xcbutilwm, xcbutilimage, mesa, libdrm, udev, systemd, dbus_libs
, libpthreadstubs, libX11, libXau, libXdmcp, libXext, libXdamage, libxshmfence, libXxf86vm
}:

stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "git-2016-01-31";
  repo = "https://github.com/Cloudef/wlc";
  rev = "faa4d3cba670576c202b0844e087b13538f772c5";

  chck_repo = "https://github.com/Cloudef/chck";
  chck_rev = "fe5e2606b7242aa5d89af2ea9fd048821128d2bc";

  wl_protos_repo = "git://anongit.freedesktop.org/wayland/wayland-protocols";
  wl_protos_rev = "0b05b70f9da245582f01581be4ca36db683682b8";
  wl_protos_rev_short = "0b05b70";

  srcs = [
   (fetchurl {
     url = "${repo}/archive/${rev}.tar.gz";
     sha256 = "cdf6a772dc90060d57aa1a915a4daff0f79802c141fec92ef2710245d727af67";
   })
   (fetchurl {
     url = "${chck_repo}/archive/${chck_rev}.tar.gz";
     sha256 = "ca316b544c48e837c32f08d613be42da10e0a3251e8e4488d1848b91ef92ab9e";
   })
   (fetchgit {
     url = "${wl_protos_repo}";
     rev = "${wl_protos_rev}";
     sha256 = "9c1cfbb570142b2109ecef4d11b17f25e94ed2e0569f522ea56f244c60465224";
   })
  ];

  sourceRoot = "wlc-${rev}";
  postUnpack = ''
    rm -rf wlc-${rev}/lib/chck wlc-${rev}/protos/wayland-protocols
    ln -s ../../chck-${chck_rev} wlc-${rev}/lib/chck
    ln -s ../../wayland-protocols-${wl_protos_rev_short} wlc-${rev}/protos/wayland-protocols
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
