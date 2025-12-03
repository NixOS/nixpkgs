{
  lib,
  asioSupport ? true,
  asio_1_32_0,
  boost,
  boost186,
  log4cxxSupport ? false,
  log4cxx,
  snappySupport ? false,
  snappy,
  zlibSupport ? true,
  zlib,
  zstdSupport ? true,
  zstd,
  gtest,
  gtestSupport ? false,
  cmake,
  curl,
  fetchFromGitHub,
  protobuf,
  jsoncpp,
  openssl,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpulsar";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "pulsar-client-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3kUyimyv0Si3zUFaIsIVdulzH8l2fxe6BO9a5L6n8I8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf # protoc
  ]
  ++ lib.optional gtestSupport gtest.dev;

  buildInputs = [
    jsoncpp
    openssl
    curl
    protobuf
  ]
  ++ lib.optional snappySupport snappy.dev
  ++ lib.optional zlibSupport zlib
  ++ lib.optional zstdSupport zstd
  ++ lib.optional log4cxxSupport log4cxx
  ++ lib.optionals asioSupport [
    # io_service was removed in 1.33.0
    asio_1_32_0
    boost
  ]
  ++ lib.optionals (!asioSupport) [
    # io_service was removed in 1.87.0
    boost186
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" gtestSupport)
    (lib.cmakeBool "USE_LOG4CXX" log4cxxSupport)
    # We enable USE_ASIO here so at least we can
    # have newer boost minus boost::asio
    (lib.cmakeBool "USE_ASIO" asioSupport)
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
    changelog = "https://github.com/apache/pulsar-client-cpp/releases/tag/v${finalAttrs.version}";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [
      corbanr
      gaelreyrol
    ];
  };
})
