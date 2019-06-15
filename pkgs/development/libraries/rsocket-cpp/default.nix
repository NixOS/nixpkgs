{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, google-gflags, openssl, folly }:

stdenv.mkDerivation rec {
  pname = "rsocket-cpp";
  version = "2019-06-13";

  src = fetchFromGitHub {
    owner = "rsocket";
    repo = "rsocket-cpp";
    rev = "14106e93e9e78d86247778bdb1b8ce41f42cd101";
    sha256 = "0wlpvpfdysa80y0iw87zx3a74mqy11g570gfj26b3l1j55rbw7nk";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=off"
    "-DBUILD_TESTS=off"
  ];

  buildInputs = [
    double-conversion
    folly
    glog
    google-gflags
    openssl
  ];

  meta = with stdenv.lib; {
    description = "C++ implementation of RSocket";
    homepage = https://github.com/rsocket/rsocket-cpp;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ pierreis ];
  };
}
