{stdenv, fetchurl, pkgconfig, libdvdread}:

stdenv.mkDerivation rec {
  pname = "libdvdnav";
  version = "6.0.1";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdnav/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0cv7j8irsv1n2dadlnhr6i1b8pann2ah6xpxic41f04my6ba6rp5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [libdvdread];

  meta = {
    homepage = http://dvdnav.mplayerhq.hu/;
    description = "A library that implements DVD navigation features such as DVD menus";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = { inherit libdvdread; };
}
