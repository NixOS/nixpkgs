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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "${version}";
    sha256 = "14pdih09h3bmgimmj9sa917x7kld49m91gvh0lcncink8rmbxvf1";
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
