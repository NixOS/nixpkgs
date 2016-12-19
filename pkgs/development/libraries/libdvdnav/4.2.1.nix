{stdenv, fetchurl, pkgconfig, libdvdread}:

stdenv.mkDerivation {
  name = "libdvdnav-4.2.1";
  
  src = fetchurl {
    url = http://dvdnav.mplayerhq.hu/releases/libdvdnav-4.2.1.tar.xz;
    sha256 = "7fca272ecc3241b6de41bbbf7ac9a303ba25cb9e0c82aa23901d3104887f2372";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [libdvdread];

  configureScript = "./configure2"; # wtf?

  preConfigure = ''
    mkdir -p $out
  '';

  # From Handbrake
  patches = [ ./A08-dvdnav-dup.patch ./P00-mingw-no-examples.patch ];

  meta = {
    homepage = http://dvdnav.mplayerhq.hu/;
    description = "A library that implements DVD navigation features such as DVD menus";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    platforms = stdenv.lib.platforms.linux;
  };

  passthru = { inherit libdvdread; };
}
