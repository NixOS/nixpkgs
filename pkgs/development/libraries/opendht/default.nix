{ stdenv, fetchFromGitHub
, cmake, pkg-config
, asio, nettle, gnutls, msgpack, readline, libargon2
}:

stdenv.mkDerivation rec {
  pname = "opendht";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = version;
    sha256 = "1q1fwk8wwk9r6bp0indpr60ql668lsk16ykslacyhrh7kg97kvhr";
  };

  nativeBuildInputs =
    [ cmake
      pkg-config
    ];

  buildInputs =
    [ asio
      nettle
      gnutls
      msgpack
      readline
      libargon2
    ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with stdenv.lib; {
    description = "A C++11 Kademlia distributed hash table implementation";
    homepage    = "https://github.com/savoirfairelinux/opendht";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ taeer olynch thoughtpolice ];
    platforms   = platforms.linux;
  };
}
