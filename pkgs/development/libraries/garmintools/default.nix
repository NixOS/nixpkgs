{ stdenv, fetchurl, libusb }:
stdenv.mkDerivation {
  name = "garmintools-0.10";
  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/garmintools/garmintools-0.10.tar.gz";
    sha256 = "1vjc8h0z4kx2h52yc3chxn3wh1krn234fg12sggbia9zjrzhpmgz";
  };
  buildInputs = [ libusb ];
  meta = {
    homepage = https://code.google.com/archive/p/garmintools/; # community clone at https://github.com/ianmartin/garmintools
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    platforms = stdenv.lib.platforms.unix;
  };
}
