args: with args;
stdenv.mkDerivation {
	name = "poppler-0.6.1";
	src = fetchurl {
		url = http://poppler.freedesktop.org/poppler-0.6.1.tar.gz;
		sha256 = "1wiz7m36wr4l0ihnawl7ww2ai0cx81ly5ych9wmyh348py4jgyyl";
	};

	propagatedBuildInputs = [qt4 zlib glib cairo freetype fontconfig libjpeg gtk];

	configureFlags = "--enable-shared --disable-static --enable-exceptions
	--enable-cairo --enable-splash --enable-poppler-glib --enable-zlib";

	patches = [ ./GDir-const.patch ./datadir_env.patch ./use_exceptions.patch ];

	preConfigure = "sed -e '/jpeg_incdirs/s@/usr@${libjpeg}@' -i configure";
}
