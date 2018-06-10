{ stdenv, fetchurl, pkgconfig, libnfc, openssl
, libobjc ? null }:

stdenv.mkDerivation rec {
  name = "libfreefare-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libfreefare/libfreefare-0.4.0.tar.bz2";
    sha256 = "0r5wfvwgf35lb1v65wavnwz2wlfyfdims6a9xpslf4lsm4a1v8xz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnfc openssl ] ++ stdenv.lib.optional stdenv.isDarwin libobjc;

  meta = with stdenv.lib; {
    description = "The libfreefare project aims to provide a convenient API for MIFARE card manipulations";
    license = licenses.lgpl3;
    homepage = https://github.com/nfc-tools/libfreefare;
    maintainers = with maintainers; [bobvanderlinden];
    platforms = platforms.unix;
  };
}
