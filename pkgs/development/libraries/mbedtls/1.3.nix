{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "mbedtls-1.3.22";

  src = fetchurl {
    url = "https://tls.mbed.org/download/${name}-gpl.tgz";
    sha256 = "0ms4s41z88mz7b6gsnp7jslms4v0115k7gw51i6kx6ng9am43l6y";
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
