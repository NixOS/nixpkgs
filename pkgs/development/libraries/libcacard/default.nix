{ stdenv, fetchurl, pkgconfig, glib, nss }:

stdenv.mkDerivation rec {
  pname = "libcacard";
  version = "2.7.0";

  src = fetchurl {
    url = "https://www.spice-space.org/download/libcacard/${pname}-${version}.tar.xz";
    sha256 = "0vyvkk4b6xjwq1ccggql13c1x7g4y90clpkqw28257azgn2a1c8n";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib nss ];

  meta = with stdenv.lib; {
    description = "Smart card emulation library";
    homepage = "https://gitlab.freedesktop.org/spice/libcacard";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.unix;
  };
}
