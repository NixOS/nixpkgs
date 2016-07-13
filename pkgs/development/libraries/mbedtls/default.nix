{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "mbedtls-2.3.0";

  src = fetchurl {
    url = "https://tls.mbed.org/download/${name}-gpl.tgz";
    sha256 = "0jfb20crlcp67shp9p8cy6vmwdjkxb0rqfbi5l5yggbrywa708r1";
  };

  nativeBuildInputs = [ perl ];

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "SHARED=1"
  ];

  installFlags = [
    "DESTDIR=\${out}"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://tls.mbed.org/;
    description = "Portable cryptographic and SSL/TLS library, aka polarssl";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
