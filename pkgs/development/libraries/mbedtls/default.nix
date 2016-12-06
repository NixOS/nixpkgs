{ stdenv, fetchurl, perl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "mbedtls-2.3.0";

  src = fetchurl {
    url = "https://tls.mbed.org/download/${name}-gpl.tgz";
    sha256 = "0jfb20crlcp67shp9p8cy6vmwdjkxb0rqfbi5l5yggbrywa708r1";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin [ makeWrapper ];

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace library/Makefile --replace "-soname" "-install_name"
    substituteInPlace tests/scripts/run-test-suites.pl --replace "LD_LIBRARY_PATH" "DYLD_LIBRARY_PATH"
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
      for prog in "$out"/bin/*; do
          wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "$out/lib"
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
