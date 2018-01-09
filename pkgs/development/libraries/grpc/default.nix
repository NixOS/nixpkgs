{ stdenv, fetchurl, cmake, zlib, c-ares, pkgconfig, openssl, protobuf, gflags }:

stdenv.mkDerivation rec
  { name = "grpc-1.8.3";
    src = fetchurl
      { url = "https://github.com/grpc/grpc/archive/v1.8.3.tar.gz";
        sha256 = "14ichjllvhkbv8sjh9j5njnagpqw2sl12n41ga90jnj7qvfwwjy1";
      };
    nativeBuildInputs = [ cmake pkgconfig ];
    buildInputs = [ zlib c-ares c-ares.cmake-config openssl protobuf gflags ];
    cmakeFlags =
      [ "-DgRPC_ZLIB_PROVIDER=package"
        "-DgRPC_CARES_PROVIDER=package"
        "-DgRPC_SSL_PROVIDER=package"
        "-DgRPC_PROTOBUF_PROVIDER=package"
        "-DgRPC_GFLAGS_PROVIDER=package"
      ];
    enableParallelBuilds = true;
  }
