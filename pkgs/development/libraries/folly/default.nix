{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, google-gflags, libiberty, openssl }:

stdenv.mkDerivation rec {
  pname = "folly";
  version = "2019.06.10.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "1lli9a01ypna6kcw00mapknjb4cdrgiggn1rsj1ayji1fwmcyyfn";
  };

  nativeBuildInputs = [ cmake ];

  # See CMake/folly-deps.cmake in the Folly source tree.
  buildInputs = [
    boost
    double-conversion
    glog
    google-gflags
    libevent
    libiberty
    openssl
  ];

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = https://github.com/facebook/folly;
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ abbradar pierreis ];
  };
}
