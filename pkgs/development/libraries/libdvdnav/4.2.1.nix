{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libdvdread,
}:

stdenv.mkDerivation rec {
  pname = "libdvdnav";
  version = "4.2.1";

  src = fetchurl {
    url = "http://dvdnav.mplayerhq.hu/releases/libdvdnav-${version}.tar.xz";
    sha256 = "7fca272ecc3241b6de41bbbf7ac9a303ba25cb9e0c82aa23901d3104887f2372";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libdvdread ];

  # The upstream supports two configuration workflow:
  # one is to generate ./configure via `autoconf`,
  # the other is to run ./configure2.
  # ./configure2 is a configureation script included in the upstream source
  # that supports common "--<name>" flags and generates config.mak and config.h.
  # See INSTALL inside the upstream source for detail.
  configureScript = "./configure2";

  configureFlags = [
    "--cc=${stdenv.cc.targetPrefix}cc"
    # Let's strip the binaries ourselves,
    # as unprefixed `strip` command is not available during cross compilation.
    "--disable-strip"
  ];

  preConfigure = ''
    mkdir -p $out
  '';

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
    "LD=${stdenv.cc.targetPrefix}ld"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
  ];

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library that implements DVD navigation features such as DVD menus";
    mainProgram = "dvdnav-config";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.linux;
  };

  passthru = {
    inherit libdvdread;
  };
}
