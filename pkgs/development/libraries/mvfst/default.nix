{ stdenv
, lib
, fetchFromGitHub
, cmake
, fizz
, folly
, gflags
, glog
, libsodium
, zlib
}:

stdenv.mkDerivation rec {
  pname = "mvfst";
  version = "2024.02.19.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "mvfst";
    rev = "v${version}";
    sha256 = "sha256-Y7T38xCKMP0yfDYcEoPCKn+ZZseMAEtvT+iY2RDrRig=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  buildInputs = [
    fizz
    folly
    folly.boost
    folly.fmt
    gflags
    glog
    libsodium
    zlib
  ];

  meta = with lib; {
    description = "An implementation of the QUIC transport protocol";
    homepage = "https://github.com/facebook/mvfst";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ris ];
  };
}
