{stdenv, fetchurl, apacheAnt}:

stdenv.mkDerivation {
	name = "martyr-0.3.9";
	builder = ./builder.sh;
	src = fetchurl {
		url = "mirror://sourceforge/martyr/martyr-0.3.9.tar.gz";
		sha256 = "1ks8j413bcby345kmq1i7av8kwjvz5vxdn1zpv0p7ywxq54i4z59";
	};
	inherit stdenv apacheAnt;
}
