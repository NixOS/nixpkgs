args: with args;
stdenv.mkDerivation rec {
	name = "lzo-2.02";
	src = fetchurl {
		url = "${meta.homepage}/download/${name}.tar.gz";
		sha256 = "1i9g9bdrmyn6546rnck3kkh8nssfaw75m2rxir4sn7bwvnsfryx2";
	};
	configureFlags = "--enable-shared --disable-static";
	meta = {
		description = "LZO is a data compresion library which is suitable for
		data de-/compression in real-time";
		homepage = http://www.oberhumer.com/opensource/lzo;
	};
}
