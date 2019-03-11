{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
	name = "aften-${version}";
	version = "0.0.8";
	src = fetchurl {
		url = "mirror://sourceforge/aften/${name}.tar.bz2";
		sha256 = "02hc5x9vkgng1v9bzvza9985ifrjd7fjr7nlpvazp4mv6dr89k47";
	};

	nativeBuildInputs = [ cmake ];

	cmakeFlags = [ "-DSHARED=ON" ];

	meta = {
		description = "An audio encoder which generates compressed audio streams based on ATSC A/52 specification";
		homepage = "http://aften.sourceforge.net/";
		license = stdenv.lib.licenses.lgpl2;
		platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
	};
}
