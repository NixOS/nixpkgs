{ stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkgconfig
, nettle
, gnutls
, libmsgpack
, readline
, libargon2
}:

stdenv.mkDerivation rec {
  name = "opendht-${version}";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "${version}";
    sha256 = "0karj37f0zq39w0ip8ahrjr6lcrrn9jd6bpzylp1m92jzs8pfki8";
  };

  buildInputs = [
    autoconf
    automake
    libtool
    pkgconfig
    nettle
    gnutls
    libmsgpack
    readline
    libargon2
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A C++11 Kademlia distributed hash table implementation";
    homepage = https://github.com/savoirfairelinux/opendht;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ taeer olynch ];
    platforms = platforms.linux;
  };
}
