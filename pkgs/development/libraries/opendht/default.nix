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
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "${version}";
    sha256 = "0nia3gkn5jqs7lf0v6jkhh1c0czdx9743imgi77kcvn98k2n6sjc";
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
