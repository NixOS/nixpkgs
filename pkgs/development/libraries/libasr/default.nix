{ stdenv, fetchurl, libevent, openssl }:

stdenv.mkDerivation rec {
  name = "libasr-${version}";
  version=  "1.0.2";

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "0d4blm0kzdhb75fq8sbcpvkc25lv5dbjaxa2ldniaf39633d3xd6";
  };

  buildInputs = [ libevent openssl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/OpenSMTPD/libasr;
    description = "Free, simple and portable asynchronous resolver library";
    license = licenses.isc;
    maintainers = [ maintainers.koral ];
    platforms = platforms.unix;
  };
}
