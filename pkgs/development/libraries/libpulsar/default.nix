{ lib
, asioSupport ? true
, asio
, boost180
, log4cxxSupport ? false
, log4cxx
, snappySupport ? false
, snappy
, zlibSupport ? true
, zlib
, zstdSupport ? true
, zstd
, gtest
, gtestSupport ? false
, cmake
, curl
, fetchFromGitHub
, protobuf
, jsoncpp
, openssl
, pkg-config
, stdenv
}:

let
  /*
    Check if null or false
    Example:
    let result = enableFeature null
    => "OFF"
    let result = enableFeature false
    => "OFF"
    let result = enableFeature «derivation»
    => "ON"
  */
  enableCmakeFeature = p: if (p == null || p == false) then "OFF" else "ON";

  defaultOptionals = [ protobuf ]
    ++ lib.optional snappySupport snappy.dev
    ++ lib.optional zlibSupport zlib
    ++ lib.optional zstdSupport zstd
    ++ lib.optional log4cxxSupport log4cxx
    ++ lib.optional asioSupport asio
    ++ lib.optional (!asioSupport) boost180;

in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "libpulsar";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "pulsar-client-cpp";
    rev = "v${version}";
    hash = "sha256-P1LhUH7V3EtWBXwPHQdN11mCjuyUyVdrtZsUItvC8xU=";
  };

  nativeBuildInputs = [ cmake pkg-config ]
    ++ defaultOptionals
    ++ lib.optional gtestSupport gtest.dev;

  buildInputs = [ jsoncpp openssl curl ]
    ++ defaultOptionals;

  cmakeFlags = [
    "-DBUILD_TESTS=${enableCmakeFeature gtestSupport}"
    "-DUSE_LOG4CXX=${enableCmakeFeature log4cxxSupport}"
    "-DUSE_ASIO=${enableCmakeFeature asioSupport}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    echo ${lib.escapeShellArg ''
      #include <pulsar/Client.h>
      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    ''} > test.cc
    $CXX test.cc -L $out/lib -I $out/include -lpulsar -o test
  '';

  meta = with lib; {
    homepage = "https://pulsar.apache.org/docs/next/client-libraries-cpp/";
    description = "Apache Pulsar C++ library";
    changelog = "https://github.com/apache/pulsar-client-cpp/releases/tag/v${version}";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ corbanr gaelreyrol ];
  };
})
