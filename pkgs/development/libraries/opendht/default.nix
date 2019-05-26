{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, nettle, gnutls, msgpack, readline, libargon2
}:

stdenv.mkDerivation rec {
  name = "opendht-${version}";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "${version}";
    sha256 = "1mj3zsywxphh9wcazyqsldwwn14r77xv9cjsmc0nmcybsl2bwnpl";
  };

  nativeBuildInputs =
    [ autoreconfHook
      pkgconfig
    ];

  buildInputs =
    [ nettle
      gnutls
      msgpack
      readline
      libargon2
    ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with stdenv.lib; {
    description = "A C++11 Kademlia distributed hash table implementation";
    homepage    = https://github.com/savoirfairelinux/opendht;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ taeer olynch thoughtpolice ];
    platforms   = platforms.linux;
  };
}
