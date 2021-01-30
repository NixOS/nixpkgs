{ lib, stdenv
, fetchFromGitHub

, cmake
, ninja
, perl # Project uses Perl for scripting and testing
, python

, enableThreading ? true # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation rec {
  pname = "mbedtls";
  version = "2.16.9"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    rev = "${pname}-${version}";
    sha256 = "0mz7n373b8d287crwi6kq2hb8ryyi228j38h25744lqai23qj5cf";
  };

  nativeBuildInputs = [ cmake ninja perl python ];

  postConfigure = lib.optionals enableThreading ''
    perl scripts/config.pl set MBEDTLS_THREADING_C    # Threading abstraction layer
    perl scripts/config.pl set MBEDTLS_THREADING_PTHREAD    # POSIX thread wrapper layer for the threading layer.
  '';

  cmakeFlags = [ "-DUSE_SHARED_MBEDTLS_LIBRARY=on" ];

  meta = with lib; {
    homepage = "https://tls.mbed.org/";
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
