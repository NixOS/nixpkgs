{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "mbedtls-1.3.10";

  src = fetchurl {
    url = "https://polarssl.org/download/${name}-gpl.tgz";
    sha256 = "0zj0vdmam52hk7c6s3y81bdb4mqawi9fskkcqlgnj8v61j7dhvvl";
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

  postInstall = ''
    rm $out/lib/lib{mbedtls.so.8,polarssl.{a,so}}
    ln -s libmbedtls.so $out/lib/libmbedtls.so.8
    ln -s libmbedtls.so $out/lib/libpolarssl.so
    ln -s libmbedtls.a $out/lib/libpolarssl.a
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://polarssl.org/;
    description = "Portable cryptographic and SSL/TLS library, aka polarssl";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
