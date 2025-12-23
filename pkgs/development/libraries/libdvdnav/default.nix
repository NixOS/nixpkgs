{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libdvdread,
}:

stdenv.mkDerivation rec {
  pname = "libdvdnav";
  version = "7.0.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdnav/${version}/libdvdnav-${version}.tar.xz";
    sha256 = "sha256-oqGPWtNtEzx0v5EGtkRYBvolOwkUGkY5JVA5S2R7Ih4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libdvdread ];

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library that implements DVD navigation features such as DVD menus";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
  };

  passthru = { inherit libdvdread; };
}
