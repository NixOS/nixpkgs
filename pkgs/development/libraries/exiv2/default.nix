args: with args;

stdenv.mkDerivation {
	name = "exiv2-0.15";
	src = fetchurl {
		url = http://www.exiv2.org/exiv2-0.15.tar.gz;
		sha256 = "0gjak1849rbw5azz4ggckmcw0r40wlr3hgwrf4s0c23k27lq4bdp";
	};
	buildInputs = [zlib];
	configureFlags = "--with-zlib=${zlib} --enable-shared --disable-static";
}
