{ fetchFromGitHub
, lib
, stdenv
, cmake
, zlib
, libuv
, openssl
, pkg-config
, examples ? false
}: stdenv.mkDerivation rec {
    pname = "cassandra-cpp-driver";
    version = "2.17.0";

    src = fetchFromGitHub {
      owner = "datastax";
      repo = "cpp-driver";
      rev = "refs/tags/${version}";
      sha256 = "sha256-sLKLaBFnGq3NIQV7Tz5aAfsL+LeLw8XDbcJt//H468k=";
    };

    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ zlib libuv openssl.dev ];

    cmakeFlags = (lib.attrsets.mapAttrsToList
      (name: value: "-DCASS_BUILD_${name}:BOOL=${if value then "ON" else "OFF"}") {
        EXAMPLES = examples;
      }) ++ [ "-DLIBUV_INCLUDE_DIR=${lib.getDev libuv}/include" ];

    meta = with lib; {
      description = "DataStax CPP cassandra driver";
      longDescription = ''
        A modern, feature-rich and highly tunable C/C++ client
        library for Apache Cassandra 2.1+ using exclusively Cassandra’s
        binary protocol and Cassandra Query Language v3.
      '';
      license = with licenses; [ asl20 ];
      platforms = platforms.x86_64;
      homepage = "https://docs.datastax.com/en/developer/cpp-driver/";
      maintainers = [ maintainers.npatsakula ];
    };
}
