{stdenv, fetchurl}:

stdenv.mkDerivation {
	name = "sqlite-3.3.6";
	src = fetchurl {
		url = "http://www.sqlite.org/sqlite-3.3.6.tar.gz";
		md5 = "a2cb1fafad5c2587e513dcbd18ace097";
	};
	configureFlags = "--enable-threadsafe --disable-tcl";
	inherit stdenv;
}
