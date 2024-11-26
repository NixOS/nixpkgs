{lib, stdenv, fetchurl, pkg-config, libdvdread}:

stdenv.mkDerivation rec {
  pname = "libdvdnav";
  version = "6.1.1";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdnav/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-wZGnR1lH0yP/doDPksD7G+gjdwGIXzdlbGTQTpjRjUg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [libdvdread];

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library that implements DVD navigation features such as DVD menus";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
  };

  passthru = { inherit libdvdread; };
}
