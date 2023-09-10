{ lib, stdenv, fetchFromGitHub
, cmake
, cunit, ncurses
, libev, nghttp3, quictls
, withJemalloc ? false, jemalloc
, curlHTTP3
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vY3RooC8ttezru6vAqbG1MU5uZhD8fLnlEYVYS3pFRk=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cunit ncurses ];
  buildInputs = [ libev nghttp3 quictls ] ++ lib.optional withJemalloc jemalloc;

  cmakeFlags = [
    "-DENABLE_STATIC_LIB=OFF"
  ];

  preConfigure = ''
    # https://github.com/ngtcp2/ngtcp2/issues/858
    # Fix ngtcp2_crypto_openssl remnants.
    substituteInPlace crypto/includes/CMakeLists.txt \
      --replace 'ngtcp2/ngtcp2_crypto_openssl.h' 'ngtcp2/ngtcp2_crypto_quictls.h'
  '';

  doCheck = true;
  enableParallelBuilding = true;

  passthru.tests = {
    inherit curlHTTP3;
  };

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/ngtcp2";
    description = "ngtcp2 project is an effort to implement QUIC protocol which is now being discussed in IETF QUICWG for its standardization.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
