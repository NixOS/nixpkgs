{stdenv, fetchurl}:

stdenv.mkDerivation {
	name = "sqlite-3.3.6";
	src = fetchurl {
		url = "http://www.sqlite.org/sqlite3-3.3.6.bin.gz";
		md5 = "7e0b5e1bf989419c662c7955fdf47ab3";
	};
	configureFlags = "--enable-threadsafe";
	inherit stdenv;
}
