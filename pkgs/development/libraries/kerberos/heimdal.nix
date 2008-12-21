args: with args;
stdenv.mkDerivation rec {
	name = "heimdal-1.0.2";

	src = fetchurl {
		urls = [ "http://www.h5l.org/dist/src/${name}.tar.gz"
                         "http://ftp.pdc.kth.se/pub/heimdal/src/${name}.tar.gz" ];
		sha256 = "1h4x41lpv2abpv5l3yjd58pfzs0kkp5sbnih9iykhwd6sii1iig6";
	};

	## ugly, X should be made an option
	configureFlags = "--enable-shared --disable-static --with-openldap=${openldap} --without-x";
	propagatedBuildInputs = [ readline db4 openssl openldap cyrus_sasl ];
}
