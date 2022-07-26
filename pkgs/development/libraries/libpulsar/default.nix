{ lib
, clang-tools
, llvmPackages
, boost17x
, protobuf
, python3Support ? false
, python3
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
, fetchurl
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

  # Not really sure why I need to do this.. If I call clang-tools without the override it defaults to a different version and fails
  clangTools = clang-tools.override { inherit stdenv llvmPackages; };
  # If boost has python enabled, then boost-python package will be installed which is used by libpulsars python wrapper
  boost = if python3Support then boost17x.override { inherit stdenv; enablePython = python3Support; python = python3; } else boost17x;
  defaultOptionals = [ boost protobuf ]
    ++ lib.optional python3Support python3
    ++ lib.optional snappySupport snappy.dev
    ++ lib.optional zlibSupport zlib
    ++ lib.optional zstdSupport zstd
    ++ lib.optional log4cxxSupport log4cxx;

in
stdenv.mkDerivation rec {
  pname = "libpulsar";
  version = "2.9.1";

  src = fetchurl {
    hash = "sha512-NKHiL7D/Lmnn6ICpQyUmmQYQETz4nZPJU9/4LMRDUQ3Pck6qDh+t6CRk+b9UQ2Vb0jvPIGTjEsSp2nC7TJk3ug==";
    url = "mirror://apache/pulsar/pulsar-${version}/apache-pulsar-${version}-src.tar.gz";
  };

  sourceRoot = "apache-pulsar-${version}-src/pulsar-client-cpp";

  # clang-tools needed for clang-format
  nativeBuildInputs = [ cmake pkg-config clangTools ]
    ++ defaultOptionals
    ++ lib.optional gtestSupport gtest.dev;

  buildInputs = [ jsoncpp openssl curl ]
    ++ defaultOptionals;

  # Needed for GCC on Linux
  NIX_CFLAGS_COMPILE = [ "-Wno-error=return-type" ];

  cmakeFlags = [
    "-DBUILD_TESTS=${enableCmakeFeature gtestSupport}"
    "-DBUILD_PYTHON_WRAPPER=${enableCmakeFeature python3Support}"
    "-DUSE_LOG4CXX=${enableCmakeFeature log4cxxSupport}"
    "-DClangTools_PATH=${clangTools}/bin"
  ];

  enableParallelBuilding = true;
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
    homepage = "https://pulsar.apache.org/docs/en/client-libraries-cpp";
    description = "Apache Pulsar C++ library";

    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.corbanr ];
  };
}
