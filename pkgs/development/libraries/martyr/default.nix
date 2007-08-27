{stdenv, fetchurl, apacheAnt}:

stdenv.mkDerivation {
	name = "martyr-0.3.9";
	builder = ./builder.sh;
	src = fetchurl {
		url = "mirror://sourceforge/martyr/martyr-0.3.9.tar.gz";
		md5 = "b716a6aaabd5622b65d6126438766260";
	};
	inherit stdenv apacheAnt;
}
