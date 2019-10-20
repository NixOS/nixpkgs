{ stdenv
, fetchFromGitHub
, fetchpatch

, cmake
, ninja
, perl # Project uses Perl for scripting and testing
, python

, enableThreading ? true # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation rec {
  pname = "mbedtls";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    rev = "${pname}-${version}";
    sha256 = "1mk3xv61wvqqrzd6jnrz8csyfnwwwwpjzywj3fsfy99p51d7wqgw";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ARMmbed/mbedtls/commit/33f66ba6fd234114aa37f0209dac031bb2870a9b.patch";
      sha256 = "0rvmiyvb8i2xqkjbaya1w88grin20a3rzz9vbi23xvxvqzy4925s";
    })
  ];

  nativeBuildInputs = [ cmake ninja perl python ];

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
    maintainers = with maintainers; [ fpletz ];
  };
}
