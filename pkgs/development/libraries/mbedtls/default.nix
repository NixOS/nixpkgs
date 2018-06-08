{ stdenv
, fetchFromGitHub

, cmake
, ninja
, perl # Project uses Perl for scripting and testing

, enableThreading ? true
}:

stdenv.mkDerivation rec {
  name = "mbedtls-${version}";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    rev = name;
    sha256 = "1d4a0jc08q3h051amv8hhh3hmqp4f1rk5z7ffyfs2g8dassm78ir";
  };

  nativeBuildInputs = [ cmake ninja perl ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace library/Makefile --replace "-soname" "-install_name"
    substituteInPlace tests/scripts/run-test-suites.pl --replace "LD_LIBRARY_PATH" "DYLD_LIBRARY_PATH"
    # Necessary for install_name_tool below
    echo "LOCAL_LDFLAGS += -headerpad_max_install_names" >> programs/Makefile
  '';

  postConfigure = stdenv.lib.optionals enableThreading ''
    perl scripts/config.pl set MBEDTLS_THREADING_C    # Threading abstraction layer
    perl scripts/config.pl set MBEDTLS_THREADING_PTHREAD    # POSIX thread wrapper layer for the threading layer.
  '';

  cmakeFlags = [ "-DUSE_SHARED_MBEDTLS_LIBRARY=on" ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libmbedcrypto.dylib $out/lib/libmbedcrypto.dylib $out/lib/libmbedtls.dylib
    install_name_tool -change libmbedcrypto.dylib $out/lib/libmbedcrypto.dylib $out/lib/libmbedx509.dylib
    install_name_tool -change libmbedx509.dylib $out/lib/libmbedx509.dylib $out/lib/libmbedtls.dylib

    for exe in $out/bin/*; do
      if [[ $exe != *.sh ]]; then
        install_name_tool -change libmbedtls.dylib $out/lib/libmbedtls.dylib $exe
        install_name_tool -change libmbedx509.dylib $out/lib/libmbedx509.dylib $exe
        install_name_tool -change libmbedcrypto.dylib $out/lib/libmbedcrypto.dylib $exe
      fi
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://tls.mbed.org/;
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
