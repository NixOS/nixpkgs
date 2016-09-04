{ stdenv, fetchurl, libusb }:
stdenv.mkDerivation {
  name = "garmintools-0.10";
  src = fetchurl {
    url = https://garmintools.googlecode.com/files/garmintools-0.10.tar.gz;
    sha256 = "1vjc8h0z4kx2h52yc3chxn3wh1krn234fg12sggbia9zjrzhpmgz";
  };
  buildInputs = [ libusb ];
  meta = {
    homepage = https://code.google.com/p/garmintools;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    platforms = stdenv.lib.platforms.unix;
  };
}
