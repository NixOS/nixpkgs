{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "mbedtls-1.3.18";

  src = fetchurl {
    url = "https://tls.mbed.org/download/${name}-gpl.tgz";
    sha256 = "188fjm0zzggxrjxnqc7zv7zz8pvys6yp1jx3xdyq8970h9qj2ad2";
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
