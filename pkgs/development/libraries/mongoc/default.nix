{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zlib,
  zstd,
  icu,
  cyrus_sasl,
  snappy,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-367qk0u81jnNA/9ruCo9wUWnCPrNjLhp9x62iEpCmE4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      openssl
      zlib
      zstd
      icu
      cyrus_sasl
      snappy
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Security
    ];

  cmakeFlags = [
    "-DBUILD_VERSION=${version}"
    "-DENABLE_UNINSTALL=OFF"
    "-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    rm -rf src/{libmongoc,libbson}
  '';

  meta = with lib; {
    description = "Official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = licenses.asl20;
    mainProgram = "mongoc-stat";
    maintainers = with maintainers; [ archer-65 ];
    platforms = platforms.all;
  };
}
