args: with args;
stdenv.mkDerivation {
	name = "enchant-1.3.0";
	src = fetchurl {
		url = http://FIXME/enchant-1.3.0.tar.gz;
		sha256 = "1vwqwsadnp4rf8wj7d4rglvszjzlcli0jyxh06h8inka1sm1al76";
	};
	buildInputs = [aspell pkgconfig glib];
	configureFlags = "--enable-shared --disable-static";
}
