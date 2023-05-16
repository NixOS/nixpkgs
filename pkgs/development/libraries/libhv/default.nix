{ lib, stdenv, fetchFromGitHub, cmake, curl, openssl, Security }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhv";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ithewei";
    repo = "libhv";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-hzqU06Gc/vNqRKe3DTdP4AihJqeuNpt2mn4GlLuGU6U=";
=======
    hash = "sha256-LMk8B/1EofcQcIF3kGmtPdM2s+/gN9ctcsybwTpf4Po=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ curl openssl ] ++ lib.optional stdenv.isDarwin Security;

  cmakeFlags = [
    "-DENABLE_UDS=ON"
    "-DWITH_MQTT=ON"
    "-DWITH_CURL=ON"
    "-DWITH_NGHTTP2=ON"
    "-DWITH_OPENSSL=ON"
    "-DWITH_KCP=ON"
  ];

  meta = with lib; {
    description = "A c/c++ network library for developing TCP/UDP/SSL/HTTP/WebSocket/MQTT client/server";
    homepage = "https://github.com/ithewei/libhv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
