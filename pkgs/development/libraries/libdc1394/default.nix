{ lib, stdenv, fetchurl, libraw1394
, libusb1, CoreServices }:

stdenv.mkDerivation rec {
  pname = "libdc1394";
  version = "2.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/libdc1394/${pname}-${version}.tar.gz";
    sha256 = "sha256-U3zreN087ycaGD9KF2GR0c7PhfAlUg5r03WLDhnmYJ8=";
  };

  buildInputs = [ libusb1 ]
    ++ lib.optional stdenv.isLinux libraw1394
    ++ lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Capture and control API for IIDC compliant cameras";
    homepage = "https://sourceforge.net/projects/libdc1394/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.viric ];
    mainProgram = "dc1394_reset_bus";
    platforms = platforms.unix;
  };
}
