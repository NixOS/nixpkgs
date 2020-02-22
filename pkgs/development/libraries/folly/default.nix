{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, gflags, libiberty, openssl }:

stdenv.mkDerivation rec {
  pname = "folly";
  version = "2019.11.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "1sgv7sdalbs7zhz3zcc95gn2h8j2xjf7hkw2c618zc3pdn6aa58w";
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
