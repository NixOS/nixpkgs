{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  mongoc,
  openssl,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "libmongocrypt";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = pname;
    rev = version;
    hash = "sha256-I4KG2BHAovin9EaF8lNzJzucARvi0Qptz5Y9gTt3WkE=";
  };

  patches = [
    # fix pkg-config files
    # submitted upstream: https://github.com/mongodb/libmongocrypt/pull/634
    (fetchpatch {
      url = "https://github.com/mongodb/libmongocrypt/commit/5514cf0a366c4d0dc1b0f2a62201f0f1161054da.diff";
      hash = "sha256-eMSn6MRnc3yKfU2u/Bg3juWiupDzY1DUGi1/HSRftIs=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      mongoc
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Security
    ];

  cmakeFlags = [
    # all three of these are required to use system libbson
    "-DUSE_SHARED_LIBBSON=ON"
    "-DMONGOCRYPT_MONGOC_DIR=USE-SYSTEM"
    "-DENABLE_ONLINE_TESTS=OFF"

    # this pulls in a library we don't have
    "-DMONGOCRYPT_ENABLE_DECIMAL128=OFF"

    # this avoids a dependency on Python
    "-DBUILD_VERSION=${version}"
  ];

  meta = with lib; {
    description = "Required C library for client-side and queryable encryption in MongoDB";
    homepage = "https://github.com/mongodb/libmongocrypt";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
