{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, nettle, gnutls, msgpack, readline, libargon2
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
