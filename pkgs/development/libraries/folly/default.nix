{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, gflags, libiberty, openssl }:

stdenv.mkDerivation rec {
  pname = "folly";
  version = "2019.10.14.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "0d32cwwza3hqsr0z4kcrk1cj26ipbwkqm6nz5335rw4k9y5kyz16";
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
