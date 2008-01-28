args: with args;
stdenv.mkDerivation rec {
	name = "loudmouth-1.3.3";

	src = fetchurl {
		url = "http://ftp.imendio.com/pub/imendio/loudmouth/src/${name}.tar.bz2";
		sha256 = "0f3xpp3pf5bxcp0kcmqa0g28vfl5gg8mj0hxhs2cx75hwgikd26x";
	};

	propagatedBuildInputs = [gnutls libidn glib];
	buildInputs = [pkgconfig];

	configureFlags = "--enable-shared --disable-static";
}
