{ lib, stdenv, fetchFromGitHub, cmake, ninja, mbedtlsSupport ? true, tlsSupport ? true, mbedtls }:

stdenv.mkDerivation rec {
  pname = "nng";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${version}";
    sha256 = "sha256-qbjMLpPk5FxH710Mf8AIraY0mERbaxVVhTT94W0EV+k=";
  };

  nativeBuildInputs = [ cmake ninja ]
    ++ lib.optionals mbedtlsSupport [ mbedtls ];

  buildInputs = lib.optional mbedtlsSupport [ mbedtls ];

  cmakeFlags = [ "-G Ninja" ]
    ++ lib.optionals mbedtlsSupport [ "-DMBEDTLS_ROOT_DIR=${mbedtls}" ]
    ++ lib.optionals (tlsSupport || mbedtlsSupport) [ "-DNNG_ENABLE_TLS=ON" ];

  meta = with lib; {
    homepage = "https://nng.nanomsg.org/";
    description = "Nanomsg next generation";
    license = licenses.mit;
    mainProgram = "nngcat";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
