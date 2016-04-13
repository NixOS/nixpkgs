{ stdenv, fetchurl, pkgconfig, libbsd, openssl, libmilter
, perl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "opendkim-2.10.3";
  src = fetchurl {
    url = "mirror://sourceforge/opendkim/files/${name}.tar.gz";
    sha256 = "06v8bqhh604sz9rh5bvw278issrwjgc4h1wx2pz9a84lpxbvm823";
  };

  configureFlags= [ "--with-milter=${libmilter}" ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ libbsd openssl libmilter perl ];

  postInstall = ''
    wrapProgram $out/sbin/opendkim-genkey \
      --prefix PATH : ${openssl.bin}/bin
  '';

  meta = with stdenv.lib; {
    description = "C library for producing DKIM-aware applications and an open source milter for providing DKIM service";
    homepage = http://www.opendkim.org/;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
