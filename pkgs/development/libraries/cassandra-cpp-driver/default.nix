{ fetchFromGitHub,
  lib, stdenv,
  cmake, zlib, libuv, openssl,
  examples ? false
}: stdenv.mkDerivation rec {
    pname = "cassandra-cpp-driver";
    version = "2.16.2";

    src = fetchFromGitHub {
      owner = "datastax";
      repo = "cpp-driver";
      rev = "refs/tags/${version}";
      sha256 = "sha256-NAvaRLhEvFjSmXcyM039wLC6IfLws2rkeRpbE5eL/rQ=";
    };

    LIBUV_ROOT_DIR = "${libuv}/";
    nativeBuildInputs = [ cmake ];
    buildInputs = [ zlib libuv openssl.dev ];

    cmakeFlags = [
      "-DCASS_BUILD_EXAMPLES:BOOL=${lib.boolToCMakeString examples}"
    ];

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
