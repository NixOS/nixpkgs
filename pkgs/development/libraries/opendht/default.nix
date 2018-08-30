{ stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkgconfig
, nettle
, gnutls
, msgpack
, readline
, libargon2
}:

stdenv.mkDerivation rec {
  name = "opendht-${version}";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "${version}";
    sha256 = "1wqib5plak9bw2bla7y4qyjqi0b00kf8mfwlml16qj3i0aq6h2cp";
  };

  buildInputs = [
    autoconf
    automake
    libtool
    pkgconfig
    nettle
    gnutls
    msgpack
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
