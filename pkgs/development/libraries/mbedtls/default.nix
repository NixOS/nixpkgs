{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "mbedtls-2.5.1";

  src = fetchurl {
    url = "https://tls.mbed.org/download/${name}-gpl.tgz";
    sha256 = "1qny1amp54vn84wp0aaj8zvblad60zcp73pdwgnykn7h0q004bri";
  };

  nativeBuildInputs = [ perl ];

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace library/Makefile --replace "-soname" "-install_name"
    substituteInPlace tests/scripts/run-test-suites.pl --replace "LD_LIBRARY_PATH" "DYLD_LIBRARY_PATH"
    # Necessary for install_name_tool below
    echo "LOCAL_LDFLAGS += -headerpad_max_install_names" >> programs/Makefile
  '';

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "SHARED=1"
  ];

  installFlags = [
    "DESTDIR=\${out}"
  ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
      install_name_tool -change libmbedcrypto.so.0 $out/lib/libmbedcrypto.so.0 $out/lib/libmbedtls.so.10
      install_name_tool -change libmbedcrypto.so.0 $out/lib/libmbedcrypto.so.0 $out/lib/libmbedx509.so.0
      install_name_tool -change libmbedx509.so.0 $out/lib/libmbedx509.so.0 $out/lib/libmbedtls.so.10

      for exe in $out/bin/*; do
          install_name_tool -change libmbedtls.so.10 $out/lib/libmbedtls.so.10 $exe
          install_name_tool -change libmbedx509.so.0 $out/lib/libmbedx509.so.0 $exe
          install_name_tool -change libmbedcrypto.so.0 $out/lib/libmbedcrypto.so.0 $exe
      done
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://tls.mbed.org/;
    description = "Portable cryptographic and SSL/TLS library, aka polarssl";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
