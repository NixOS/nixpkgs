{lib, stdenv, fetchurl, pkg-config, libdvdread}:

stdenv.mkDerivation rec {
  pname = "libdvdnav";
  version = "6.1.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdnav/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0nzf1ir27s5vs1jrisdiw9ag2sc160k3gv7nplv9ypppm5gb35zn";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [libdvdread];

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "A library that implements DVD navigation features such as DVD menus";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
  };

  passthru = { inherit libdvdread; };
}
