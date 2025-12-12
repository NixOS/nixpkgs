{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  zlib,
  libuv,
  openssl,
  pkg-config,
  examples ? false,
}:
stdenv.mkDerivation rec {
  pname = "cassandra-cpp-driver";
  version = "2.17.1";

  src = fetchFromGitHub {
    owner = "datastax";
    repo = "cpp-driver";
    tag = version;
    sha256 = "sha256-GuvmKHJknudyn7ahrn/8+kKUA4NW5UjCfkYoX3aTE+Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    zlib
    libuv
    openssl.dev
  ];

  cmakeFlags =
    (lib.attrsets.mapAttrsToList
      (name: value: "-DCASS_BUILD_${name}:BOOL=${if value then "ON" else "OFF"}")
      {
        EXAMPLES = examples;
      }
    )
    ++ [ "-DLIBUV_INCLUDE_DIR=${lib.getDev libuv}/include" ];

  meta = {
    description = "DataStax CPP cassandra driver";
    longDescription = ''
      A modern, feature-rich and highly tunable C/C++ client
      library for Apache Cassandra 2.1+ using exclusively Cassandra’s
      binary protocol and Cassandra Query Language v3.
    '';
    license = with lib.licenses; [ asl20 ];
    platforms = lib.platforms.x86_64;
    homepage = "https://docs.datastax.com/en/developer/cpp-driver/";
    maintainers = [ lib.maintainers.npatsakula ];
  };
}
