args: with args;
stdenv.mkDerivation rec {
	name = "heimdal-1.0.2";

	src = fetchurl {
		url = "http://ftp.pdc.kth.se/pub/heimdal/src/${name}.tar.gz";
		sha256 = "1h4x41lpv2abpv5l3yjd58pfzs0kkp5sbnih9iykhwd6sii1iig5";
	};

	configureFlags = "--enable-shared --disable-static --with-openldap=${openldap}";
	buildInputs = [ readline db4 openssl openldap cyrus_sasl ];
}
