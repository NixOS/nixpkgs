args: with args;
stdenv.mkDerivation rec {
	name = "jasper-1.900.1";

	src = fetchurl {
		url = "http://www.ece.uvic.ca/~mdadams/jasper/software/${name}.zip";
		sha256 = "154l7zk7yh3v8l2l6zm5s2alvd2fzkp6c9i18iajfbna5af5m43b";
	};

	buildInputs = [ unzip libjpeg xproto libX11 libICE freeglut mesa libXmu
		libXi libXext libXt ];
	configureFlags = "--enable-shared --disable-static --with-x";

	meta = {
		homepage = http://www.ece.uvic.ca/~mdadams/jasper/;
		description = "JasPer JPEG2000 Library";
	};
}
