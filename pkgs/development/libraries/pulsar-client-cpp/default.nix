{ stdenv
, lib
, pkgs
, fetchurl
, boost17x
, clang
, cmake
, curl
, gcc
, jsoncpp
, log4cxx
, openssl
, pkgconfig
, protobuf
, python3
, snappy
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "pulsar-client-cpp";
  version = "2.8.1";

  src = fetchurl {
    sha512 = "23i95k6gs5lh6gw6v6hybv6z8rfzc3mfgj2agb6iicad9ia2sf46wr3rqzi9bdhp0c990vcvn72bkz13i0hnh1hj5gnwqin339a2g0x";
    url = "https://archive.apache.org/dist/pulsar/pulsar-${version}/apache-pulsar-${version}-src.tar.gz";
  };

  sourceRoot = "apache-pulsar-${version}-src/pulsar-client-cpp";

  # python3 used in cmake script to calculate some values
  nativeBuildInputs = [ cmake python3 pkgconfig ]
    ++ lib.optionals stdenv.isDarwin [ clang ]
    ++ lib.optionals stdenv.isLinux [ gcc ];

  buildInputs = [ boost17x jsoncpp log4cxx openssl protobuf snappy zstd curl zlib ];

  # since we cant expand $out in cmakeFlags
  preConfigure = ''cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_LIBDIR=${placeholder "out"}/lib"'';

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DBUILD_PYTHON_WRAPPER=OFF"
  ];

  patches = [ ./reader_configuration_includes.diff ];
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
  ${if stdenv.isDarwin
    then "$CC++ test.cc -L $out/lib -I $out/include -lpulsar -o test"
    else "g++ test.cc -L $out/lib -I $out/include -lpulsar -o test" }
  '';

  meta = with lib; {
    homepage = "https://pulsar.apache.org/docs/en/client-libraries-cpp";
    description = "Apache Pulsar C++ library";
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
    license = licenses.asl20;
    maintainers = with maintainers; [ gdifolco ];
  };
}
