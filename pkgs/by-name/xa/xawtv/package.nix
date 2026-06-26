{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  libjpeg,
  libx11,
  libxt,
  alsa-lib,
  aalib,
  libxft,
  xorgproto,
  libv4l,
  libfs,
  libxaw,
  libxpm,
  libxext,
  libsm,
  libice,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xawtv";
  version = "3.107";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/xawtv/xawtv-${finalAttrs.version}.tar.bz2";
    sha256 = "055p0wia0xsj073l8mg4ifa6m81dmv6p45qyh99brramq5iylfy5";
  };

  patches = [
    ./0001-Fix-build-for-glibc-2.32.patch
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  buildInputs = [
    ncurses
    libjpeg
    libx11
    libxt
    libxft
    xorgproto
    libfs
    perl
    alsa-lib
    aalib
    libxaw
    libxpm
    libxext
    libsm
    libice
    libv4l
  ];

  makeFlags = [
    "SUID_ROOT=" # do not try to setuid
    "resdir=${placeholder "out"}/share/X11"
  ];

  meta = {
    description = "TV application for Linux with apps and tools such as a teletext browser";
    license = lib.licenses.gpl2;
    homepage = "https://www.kraxel.org/blog/linux/xawtv/";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
