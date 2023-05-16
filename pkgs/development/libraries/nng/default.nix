{ lib, stdenv, fetchFromGitHub, cmake, ninja, mbedtlsSupport ? true, mbedtls }:

stdenv.mkDerivation rec {
  pname = "nng";
  version = "1.6.0-prerelease";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
<<<<<<< HEAD
    rev = "8e1836f57e8bcdb228dd5baadc71dfbf30b544e0";
    sha256 = "sha256-Q08/Oxv9DLCHp7Hf3NqNa0sHq7qwM6TfGT8gNyiwin8=";
=======
    rev = "539e559e65cd8f227c45e4b046ac41c0edcf6c32";
    sha256 = "sha256-86+f0um25Ywn78S2JrV54K7k3O6ots0q2dCco1aK0xM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ninja ]
    ++ lib.optionals mbedtlsSupport [ mbedtls ];

  buildInputs = lib.optionals mbedtlsSupport [ mbedtls ];

  cmakeFlags = [ "-G Ninja" "-DNNG_ENABLE_TLS=ON" ]
    ++ lib.optionals mbedtlsSupport [ "-DMBEDTLS_ROOT_DIR=${mbedtls}" ];

  meta = with lib; {
    homepage = "https://nng.nanomsg.org/";
    description = "Nanomsg next generation";
    license = licenses.mit;
    mainProgram = "nngcat";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
