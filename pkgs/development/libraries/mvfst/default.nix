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
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "mvfst";
    rev = "v${version}";
    sha256 = "sha256-KjNTDgpiR9EG42Agl2JFJoPo5+8GlS27oPMWpdLq2v8=";
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
