{ stdenv, fetchurl, pkgconfig, zlib, bzip2, libmcrypt, libmhash }:

stdenv.mkDerivation rec {
  name = "libgringotts-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "https://sourceforge.net/projects/gringotts.berlios/files/${name}.tar.bz2";
    sha256 = "1ldz1lyl1aml5ci1mpnys8dg6n7khpcs4zpycak3spcpgdsnypm7";
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
