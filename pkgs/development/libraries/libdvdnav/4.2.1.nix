{lib, stdenv, fetchurl, pkg-config, libdvdread}:

stdenv.mkDerivation rec {
  pname = "libdvdnav";
  version = "4.2.1";

  src = fetchurl {
    url = "http://dvdnav.mplayerhq.hu/releases/libdvdnav-${version}.tar.xz";
    sha256 = "7fca272ecc3241b6de41bbbf7ac9a303ba25cb9e0c82aa23901d3104887f2372";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [libdvdread];

  configureScript = "./configure2"; # wtf?

  preConfigure = ''
    mkdir -p $out
  '';

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "A library that implements DVD navigation features such as DVD menus";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.linux;
  };

  passthru = { inherit libdvdread; };
}
