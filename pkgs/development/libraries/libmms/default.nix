{ stdenv, fetchurl, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libmms-0.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/libmms/${name}.tar.gz";
    sha256 = "0cm4gq5jm8wj04biai6cyvlvdwv286vb3ycyzi870z9d2xi1p4q1";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://libmms.sourceforge.net;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
