{stdenv, fetchurl}:

stdenv.mkDerivation {
	name = "sqlite-3.3.5";
	src = fetchurl {
		url = "http://www.sqlite.org/sqlite-3.3.5.tar.gz";
		md5 = "dd2a7b6f2a07a4403a0b5e17e8ed5b88";
	};
	configureFlags = "--enable-threadsafe";
	inherit stdenv;
}
