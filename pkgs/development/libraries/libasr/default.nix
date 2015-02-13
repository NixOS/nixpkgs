{ stdenv, fetchurl, libevent, openssl }:

stdenv.mkDerivation rec {
  name = "libasr-${version}";
  version=  "1.0.1";

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "10h1c9b58msbggns8k2m0857zmbldb0x8ghk3aay88yn2bip2916";
  };

  buildInputs = [ libevent openssl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/OpenSMTPD/libasr;
    description = "Free, simple and portable asynchronous resolver library";
    license = licenses.isc;
    maintainers = [ maintainers.koral ];
  };
}
