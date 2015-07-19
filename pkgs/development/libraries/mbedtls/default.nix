{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "mbedtls-1.3.11";

  src = fetchurl {
    url = "https://polarssl.org/download/${name}-gpl.tgz";
    sha256 = "1js1lk6hvw9l3nhjhnhzfazfbnlcmk229hmnlm7jli3agc1979b7";
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
    homepage = https://polarssl.org/;
    description = "Portable cryptographic and SSL/TLS library, aka polarssl";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
