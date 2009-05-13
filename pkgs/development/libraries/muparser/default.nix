{stdenv, fetchurl}:

stdenv.mkDerivation {
	name = "muparser-1.30";
	src = fetchurl {
		url = mirror://sourceforge/muparser/muparser_v130.tar.gz;
		sha256 = "164wak2sva6z9vq3anrciz1npyk2x3wqkz6xwp9ld3gmdqbdn8s4";
	};
}
