{ stdenv
, fetchFromGitHub

, cmake
, ninja
, perl # Project uses Perl for scripting and testing

, enableThreading ? true # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation rec {
  name = "mbedtls-${version}";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    rev = name;
    sha256 = "09snlzlbn8yq95dnfbj2g5bh6y4q82xkaph7qp9ddnlqiaqcji2h";
  };

  nativeBuildInputs = [ cmake ninja perl ];

  postConfigure = stdenv.lib.optionals enableThreading ''
    perl scripts/config.pl set MBEDTLS_THREADING_C    # Threading abstraction layer
    perl scripts/config.pl set MBEDTLS_THREADING_PTHREAD    # POSIX thread wrapper layer for the threading layer.
  '';

  cmakeFlags = [ "-DUSE_SHARED_MBEDTLS_LIBRARY=on" ];

  meta = with stdenv.lib; {
    homepage = https://tls.mbed.org/;
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
