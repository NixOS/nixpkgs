{ lib, stdenv
, fetchFromGitHub

, cmake
, ninja
, perl # Project uses Perl for scripting and testing
, python3

, enableThreading ? true # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation rec {
  pname = "mbedtls";
  version = "2.26.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    rev = "${pname}-${version}";
    sha256 = "0scwpmrgvg6q7rvqkc352d2fqlsx0aylcbyibcp1f1rsn8iiif2m";
  };

  nativeBuildInputs = [ cmake ninja perl python3 ];

  strictDeps = true;

  postConfigure = lib.optionals enableThreading ''
    perl scripts/config.pl set MBEDTLS_THREADING_C    # Threading abstraction layer
    perl scripts/config.pl set MBEDTLS_THREADING_PTHREAD    # POSIX thread wrapper layer for the threading layer.
  '';

  cmakeFlags = [ "-DUSE_SHARED_MBEDTLS_LIBRARY=on" ];
  NIX_CFLAGS_COMPILE = [
    "-Wno-error=format"
    "-Wno-error=format-truncation"
  ];

  meta = with lib; {
    homepage = "https://tls.mbed.org/";
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
