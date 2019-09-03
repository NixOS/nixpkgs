{ stdenv, fetchurl, libtool, unbound, libidn, m4, file
, openssl, doxygen, autoreconfHook, automake }:

stdenv.mkDerivation rec {
  pname = "getdns";
  version = "1.5.1";

  src = fetchurl {
    url = "https://getdnsapi.net/releases/${pname}-1-5-1/${pname}-${version}.tar.gz";
    sha256 = "5686e61100599c309ce03535f9899a5a3d94a82cc08d10718e2cd73ad3dc28af";
  };

  nativeBuildInputs = [ libtool m4 autoreconfHook automake file ];

  buildInputs = [ unbound libidn openssl doxygen ];

  patchPhase = ''
    substituteInPlace m4/acx_openssl.m4 \
      --replace /usr/local/ssl ${openssl.dev}
    '';

  meta = with stdenv.lib; {
    description = "A modern asynchronous DNS API";
    longDescription = ''
      getdns is an implementation of a modern asynchronous DNS API; the
      specification was originally edited by Paul Hoffman. It is intended to make all
      types of DNS information easily available to application developers and non-DNS
      experts. DNSSEC offers a unique global infrastructure for establishing and
      enhancing cryptographic trust relations. With the development of this API the
      developers intend to offer application developers a modern and flexible
      interface that enables end-to-end trust in the DNS architecture, and which will
      inspire application developers to implement innovative security solutions in
      their applications.
'';
    homepage = https://getdnsapi.net;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
