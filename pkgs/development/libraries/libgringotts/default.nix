{ stdenv, fetchurl, pkgconfig, zlib, bzip2, libmcrypt, libmhash }:

stdenv.mkDerivation rec {
  name = "libgringotts-${version}";
  version = "1.1.2";

  src = fetchurl {
    url = "http://libgringotts.sourceforge.net/current/${name}.tar.bz2";
    sha256 = "1bzfnpf2gwc2bisbrw06s63g9z9v4mh1n9ksqr6pbgj2prz7bvlk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib bzip2 libmcrypt libmhash ];

  meta = with stdenv.lib; {
    description = "A small library to encapsulate data in an encrypted structure";
    homepage = http://libgringotts.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
