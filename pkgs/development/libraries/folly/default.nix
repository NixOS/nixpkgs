{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, gflags, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2019.06.17.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "0v639yqk029c585x3140rdfbz3xrdjwc858bqfy4yv31pyrn608l";
  };

  nativeBuildInputs = [ cmake ];

  # See CMake/folly-deps.cmake in the Folly source tree.
  buildInputs = [
    boost
    double-conversion
    glog
    gflags
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
