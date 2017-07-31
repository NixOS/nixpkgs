{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "mbedtls-1.3.20";

  src = fetchurl {
    url = "https://tls.mbed.org/download/${name}-gpl.tgz";
    sha256 = "0vv69c1c5rr7jcwwivx06fbfixgig90pjznh2c6cn841hgwm9z00";
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
