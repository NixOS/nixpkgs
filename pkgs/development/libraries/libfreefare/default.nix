{ stdenv, fetchurl, pkgconfig, libnfc, openssl
, libobjc ? null }:

stdenv.mkDerivation rec {
  name = "libfreefare-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://libfreefare.googlecode.com/files/libfreefare-0.4.0.tar.bz2";
    sha256 = "0r5wfvwgf35lb1v65wavnwz2wlfyfdims6a9xpslf4lsm4a1v8xz";
  };

  buildInputs = [ pkgconfig libnfc openssl ] ++ stdenv.lib.optional stdenv.isDarwin libobjc;

  meta = with stdenv.lib; {
    description = "The libfreefare project aims to provide a convenient API for MIFARE card manipulations";
    license = licenses.gpl3;
    homepage = http://code.google.com/p/libfreefare/;
    maintainers = with maintainers; [bobvanderlinden];
    platforms = platforms.unix;
  };
}
