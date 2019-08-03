{ stdenv, fetchurl, pkgconfig, glib, nss }:

stdenv.mkDerivation rec {
  name = "libcacard-${version}";
  version = "2.6.1";

  src = fetchurl {
    url = "https://www.spice-space.org/download/libcacard/${name}.tar.xz";
    sha256 = "1w6y0kiakhg7dgyf8yqpm4jj6jiv17zhy9lp3d7z32q1pniccxk2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib nss ];

  meta = with stdenv.lib; {
    description = "Smart card emulation library";
    homepage = https://gitlab.freedesktop.org/spice/libcacard;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.unix;
  };
}
