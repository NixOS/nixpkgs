{ lib, stdenv, fetchFromGitHub, cmake, ninja, mbedtlsSupport ? true, mbedtls }:

stdenv.mkDerivation rec {
  pname = "nng";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${version}";
    hash = "sha256-Kq8QxPU6SiTk0Ev2IJoktSPjVOlAS4/e1PQvw2+e8UA=";
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
