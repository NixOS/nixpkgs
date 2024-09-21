{ lib
, stdenv
, fetchFromGitHub
, Security
, cmake
, pkg-config
, asio
, nettle
, gnutls
, msgpack-cxx
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
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "v${version}";
    hash = "sha256-s172Sj1EvV7Lmnmd+xyKmYF2cDEa8Bot10ovggEsOFg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    asio
    fmt
    nettle
    gnutls
    msgpack-cxx
    readline
    libargon2
  ] ++ lib.optionals enableProxyServerAndClient [
    jsoncpp
    restinio
    http-parser
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  cmakeFlags = lib.optionals enableProxyServerAndClient [
    "-DOPENDHT_PROXY_SERVER=ON"
    "-DOPENDHT_PROXY_CLIENT=ON"
  ] ++ lib.optionals enablePushNotifications [
    "-DOPENDHT_PUSH_NOTIFICATIONS=ON"
  ];

  # https://github.com/savoirfairelinux/opendht/issues/612
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with lib; {
    description = "C++11 Kademlia distributed hash table implementation";
    homepage = "https://github.com/savoirfairelinux/opendht";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ taeer olynch thoughtpolice ];
    platforms = platforms.unix;
  };
}
