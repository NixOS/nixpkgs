{stdenv, fetchurl, pkgconfig, libdvdread}:

stdenv.mkDerivation rec {
  name = "libdvdnav-${version}";
  version = "5.0.3";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdnav/${version}/${name}.tar.bz2";
    sha256 = "5097023e3d2b36944c763f1df707ee06b19dc639b2b68fb30113a5f2cbf60b6d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [libdvdread];

  meta = {
    homepage = http://dvdnav.mplayerhq.hu/;
    description = "A library that implements DVD navigation features such as DVD menus";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
  };

  passthru = { inherit libdvdread; };
}
