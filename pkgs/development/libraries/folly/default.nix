{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, google-gflags, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2019.05.27.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "00xacaziqllps069xzg7iz68rj5hr8mj3rbi4shkrr9jq51y9ikj";
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = https://github.com/facebook/folly;
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ abbradar pierreis ];
  };
}
