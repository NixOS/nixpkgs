{ lib, stdenv, fetchFromGitHub
, cmake
, cunit, ncurses
, libev, nghttp3, quictls
, withJemalloc ? false, jemalloc
, curlHTTP3
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
<<<<<<< HEAD
  version = "0.17.0";
=======
  version = "0.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vY3RooC8ttezru6vAqbG1MU5uZhD8fLnlEYVYS3pFRk=";
=======
    hash = "sha256-VsacRYvjTWVx2ga952s1vs02GElXIW6umgcYr3UCcgE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cunit ncurses ];
  buildInputs = [ libev nghttp3 quictls ] ++ lib.optional withJemalloc jemalloc;

  cmakeFlags = [
    "-DENABLE_STATIC_LIB=OFF"
  ];

<<<<<<< HEAD
  preConfigure = ''
    # https://github.com/ngtcp2/ngtcp2/issues/858
    # Fix ngtcp2_crypto_openssl remnants.
    substituteInPlace crypto/includes/CMakeLists.txt \
      --replace 'ngtcp2/ngtcp2_crypto_openssl.h' 'ngtcp2/ngtcp2_crypto_quictls.h'
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
