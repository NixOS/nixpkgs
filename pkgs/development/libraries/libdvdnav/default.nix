{stdenv, fetchurl, pkgconfig, libdvdread}:

stdenv.mkDerivation rec {
  name = "libdvdnav-${version}";
  version = "6.0.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdnav/${version}/${name}.tar.bz2";
    sha256 = "062njcksmpgw9yv3737qkf93r2pzhaxi9szqjabpa8d010dp38ph";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [libdvdread];

  meta = {
    homepage = http://dvdnav.mplayerhq.hu/;
    description = "A library that implements DVD navigation features such as DVD menus";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    platforms = stdenv.lib.platforms.linux;
  };

  passthru = { inherit libdvdread; };
}
