{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  zlib,
  bzip2,
  libmcrypt,
  libmhash,
}:

stdenv.mkDerivation rec {
  pname = "libgringotts";
  version = "1.2.1";

  src = fetchurl {
    url = "https://sourceforge.net/projects/gringotts.berlios/files/${pname}-${version}.tar.bz2";
    sha256 = "1ldz1lyl1aml5ci1mpnys8dg6n7khpcs4zpycak3spcpgdsnypm7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    bzip2
    libmcrypt
    libmhash
  ];

  meta = with lib; {
    description = "Small library to encapsulate data in an encrypted structure";
    homepage = "https://libgringotts.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
