args: with args;
stdenv.mkDerivation rec {
	name = "gnutls-2.1.5";
	src = fetchurl {
		url = "${meta.homepage}/releases/${name}.tar.bz2";
		sha256 = "0idkp54d1w1c6l17pl41p2mqabcb1qm2akhfmp4mxwa5mabkiyld";
	};
	buildInputs = [zlib lzo libgcrypt];
  
  meta = {
    description = "The GNU Transport Layer Security Library";
    homepage = http://www.gnu.org/software/gnutls/;
    license = "LGPL";
  };
}
