{ lib, stdenv, fetchurl, libraw1394
, libusb1, CoreServices }:

stdenv.mkDerivation rec {
  pname = "libdc1394";
  version = "2.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/libdc1394/${pname}-${version}.tar.gz";
    sha256 = "1v8gq54n1pg8izn7s15yylwjf8r1l1dmzbm2yvf6pv2fmb4mz41b";
  };

  buildInputs = [ libusb1 ]
    ++ lib.optional stdenv.isLinux libraw1394
    ++ lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/libdc1394/";
    description = "Capture and control API for IIDC compliant cameras";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}
