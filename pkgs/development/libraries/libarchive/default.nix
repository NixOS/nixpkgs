args: with args;
stdenv.mkDerivation rec {
	name = "libarchive-2.4.11";

	src = fetchurl {
		url = "http://FIXME_dont_remember/${name}.tar.gz";
		sha256 = "1iq5hs4hbqyl6sqiqlaj3j89vpfqx6zv974c965nxjvmwy816dbz";
	};

	buildInputs = [zlib];

	meta = {
		description = "A library for reading and writing streaming archives";
	};
}
