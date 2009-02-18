{ fetchurl, stdenv, qt4Support ? false, qt4 ? null
, cairo, freetype, fontconfig, zlib, libjpeg
, pkgconfig, glib, gtk }:

assert qt4Support -> (qt4 != null);

stdenv.mkDerivation rec {
	name = "poppler-0.8.4";

	src = fetchurl {
		url = "http://poppler.freedesktop.org/${name}.tar.gz";
		sha256 = "0yi590vgqwjqmqspflxycbnfxjdcwa1fx9ark3diav3yn105gga5";
	};

	buildInputs = [pkgconfig zlib glib cairo freetype fontconfig libjpeg gtk]
    ++ (if qt4Support then [qt4] else []);

	configureFlags = "--enable-shared --disable-static --enable-exceptions
	--enable-cairo --enable-splash --enable-poppler-glib --enable-zlib "
  + (if qt4Support then "--enable-qt-poppler" else "--disable-qt-poppler");

	patches = [ ./GDir-const.patch

              # XXX: This patch no longer applies, what was the point of it?
              # ./datadir_env.patch

              ./use_exceptions.patch ];

	preConfigure = "sed -e '/jpeg_incdirs/s@/usr@${libjpeg}@' -i configure";

#  doCheck = true;

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Poppler, a PDF rendering library";
    license = "GPLv2";
  };
}
