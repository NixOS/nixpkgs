{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, google-gflags, libiberty, openssl, folly, libsodium, gtest, zlib }:

stdenv.mkDerivation rec {
  pname = "fizz";
  version = "2019.06.10.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    rev = "v${version}";
    sha256 = "1v7ry6yl6xnpr01ix25v4m19n69finkl7412594sbvssdfvvg2lb";
  };

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../fizz";
  NIX_LDFLAGS = "-lz";

  buildInputs = [
    boost
    double-conversion
    folly
    glog
    google-gflags
    gtest
    libevent
    libiberty
    libsodium
    openssl
    zlib
  ];

  meta = with stdenv.lib; {
    description = "C++14 implementation of the TLS-1.3 standard";
    homepage = https://github.com/facebookincubator/fizz;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ pierreis ];
  };
}
