{ stdenv, fetchurl, libtool, unbound, libidn, m4, file
, openssl, doxygen, autoreconfHook, automake }:

stdenv.mkDerivation rec {
  pname = "getdns";
  name = "${pname}-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "https://getdnsapi.net/releases/${pname}-1-5-0/${pname}-${version}.tar.gz";
    sha256 = "577182c3ace919ee70cee5629505581a10dc530bd53fe5c241603ea91c84fa84";
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
