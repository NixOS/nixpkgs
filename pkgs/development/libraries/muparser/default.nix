{stdenv, fetchurl}:

stdenv.mkDerivation {
	name = "muparser-1.34";
	src = fetchurl {
		url = mirror://sourceforge/muparser/muparser_v134.tar.gz;
		sha256 = "0xi27xjj7bwwf5nw3n2lynpr76al3vp204zwh71wkfnhwbzksg8f";
	};

  meta = {
    homepage = http://muparser.sourceforge.net;
    description = "An extensible high performance math expression parser library written in C++";
    license = "MIT";
  };
}
