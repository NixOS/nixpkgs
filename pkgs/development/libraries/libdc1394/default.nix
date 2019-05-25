{ stdenv, fetchurl, libraw1394,
libusb1, CoreServices }:

stdenv.mkDerivation rec {
  name = "libdc1394-${version}";
  version = "2.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/libdc1394/${name}.tar.gz";
    sha256 = "1v8gq54n1pg8izn7s15yylwjf8r1l1dmzbm2yvf6pv2fmb4mz41b";
  };

  buildInputs = [ libusb1 ]
    ++ stdenv.lib.optional stdenv.isLinux libraw1394
    ++ stdenv.lib.optional stdenv.isDarwin CoreServices;

  patches = stdenv.lib.optional stdenv.isDarwin ./darwin-fixes.patch;

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/libdc1394/;
    description = "Capture and control API for IIDC compliant cameras";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}
