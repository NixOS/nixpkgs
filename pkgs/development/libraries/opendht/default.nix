{ lib
, stdenv
, fetchFromGitHub
, Security
, cmake
, pkg-config
, asio
, nettle
, gnutls
, msgpack
, readline
, libargon2
, jsoncpp
, restinio
, http-parser
, openssl
, fmt
, enableProxyServerAndClient ? false
, enablePushNotifications ? false
}:

stdenv.mkDerivation rec {
  pname = "opendht";
  version = "2.4.9";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "v${version}";
    sha256 = "sha256-S/eJrSueJOv3+cUyzcCE3l287l0ihvzOZHB6ZCHtHpQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    asio
    nettle
    gnutls
    msgpack
    readline
    libargon2
  ] ++ lib.optionals enableProxyServerAndClient [
    jsoncpp
    restinio
    http-parser
    openssl
    fmt
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  cmakeFlags = lib.optionals enableProxyServerAndClient [
    "-DOPENDHT_PROXY_SERVER=ON"
    "-DOPENDHT_PROXY_CLIENT=ON"
  ] ++ lib.optionals enablePushNotifications [
    "-DOPENDHT_PUSH_NOTIFICATIONS=ON"
  ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with lib; {
    description = "A C++11 Kademlia distributed hash table implementation";
    homepage = "https://github.com/savoirfairelinux/opendht";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ taeer olynch thoughtpolice ];
    platforms = platforms.unix;
  };
}
