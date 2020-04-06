{ stdenv, fetchurl, unbound, libidn2, openssl, doxygen, cmake }:

stdenv.mkDerivation rec {
  pname = "getdns";
  version = "1.6.0";
  versionRewrite = builtins.splitVersion version;

  src = fetchurl {
    url = "https://getdnsapi.net/releases/${pname}-${
        builtins.concatStringsSep "-" versionRewrite
      }/${pname}-${version}.tar.gz";
    sha256 = "0jhg7258wz287kjymimvdvv04n69lwxdc3sb62l2p453f5s77ra0";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ unbound libidn2 openssl doxygen ];

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
    homepage = "https://getdnsapi.net";
    maintainers = with maintainers; [ leenaars ehmry ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
