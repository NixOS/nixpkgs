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
  version = "2.4.10";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "v${version}";
    sha256 = "sha256-2jTphFpBsm72UDzlBlCP1fWk1qNuxicwVJtrEutOjM0=";
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

  # https://github.com/savoirfairelinux/opendht/issues/612
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with lib; {
    description = "A C++11 Kademlia distributed hash table implementation";
    homepage = "https://github.com/savoirfairelinux/opendht";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ taeer olynch thoughtpolice ];
    platforms = platforms.unix;
  };
}
