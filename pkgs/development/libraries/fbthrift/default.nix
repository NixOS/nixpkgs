{ stdenv, fetchFromGitHub, cmake, bison, boost, libevent, double-conversion
, fizz, flex, fmt, folly, glog, google-gflags, libiberty, openssl, rsocket-cpp
, wangle, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "fbthrift";
  version = "2019.06.10.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fbthrift";
    rev = "v${version}";
    sha256 = "1fx7awkmsqiy92nsxd78zfpkfvga8xwdhza87kml17v0zspf3b2w";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  cmakeFlags = stdenv.lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13" # For aligned allocation
  ];

  buildInputs = [
    boost
    double-conversion
    fizz
    fmt
    folly
    glog
    google-gflags
    libevent
    libiberty
    openssl
    rsocket-cpp
    wangle
    zlib
    zstd
  ];

  meta = with stdenv.lib; {
    description = "Facebook's branch of Apache Thrift";
    homepage = https://github.com/facebook/fbthrift;
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ pierreis ];
  };
}
