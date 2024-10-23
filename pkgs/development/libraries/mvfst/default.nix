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
  version = "2024.05.06.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "mvfst";
    rev = "v${version}";
    sha256 = "sha256-kl5xO4cdR+tULzA8pd3o+CwJ2fvygBqNUYTKF8J45Bk=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
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
    description = "Implementation of the QUIC transport protocol";
    homepage = "https://github.com/facebook/mvfst";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ris ];
  };
}
