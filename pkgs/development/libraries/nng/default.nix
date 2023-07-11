{ lib, stdenv, fetchFromGitHub, cmake, ninja, mbedtlsSupport ? true, mbedtls }:

stdenv.mkDerivation rec {
  pname = "nng";
  version = "1.6.0-prerelease";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "8e1836f57e8bcdb228dd5baadc71dfbf30b544e0";
    sha256 = "sha256-Q08/Oxv9DLCHp7Hf3NqNa0sHq7qwM6TfGT8gNyiwin8=";
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
