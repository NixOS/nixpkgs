{ stdenv, fetchFromGitHub, cmake, boost, libevent, double-conversion, glog
, google-gflags, openssl, fizz, folly, gtest }:

stdenv.mkDerivation rec {
  pname = "wangle";
  version = "2019.06.10.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wangle";
    rev = "v${version}";
    sha256 = "034callgv3n09hcmd6bs2lxvfs1db6654g2ihj1zg6y03az9ijy0";
  };

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../wangle";

  cmakeFlags = stdenv.lib.optionals stdenv.isDarwin [
    "-DBUILD_TESTS=off" # Tests fail on Darwin due to missing utimensat
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13" # For aligned allocation
  ];

  buildInputs = [
    boost
    double-conversion
    fizz
    folly
    gtest
    glog
    google-gflags
    libevent
    openssl
  ];

  meta = with stdenv.lib; {
    description = "An open-source C++ networking library";
    longDescription = ''
      Wangle is a framework providing a set of common client/server
      abstractions for building services in a consistent, modular, and
      composable way.
    '';
    homepage = https://github.com/facebook/wangle;
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ pierreis ];
  };
}
