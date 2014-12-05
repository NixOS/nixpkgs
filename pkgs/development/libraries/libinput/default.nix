{ stdenv, fetchurl, pkgconfig, mtdev, udev, libevdev }:

stdenv.mkDerivation rec {
  name = "libinput-0.6.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libinput/${name}.tar.xz";
    sha256 = "1g5za42f60vw87982vjh0n6r78qajj34l323p7623fbw3rvmbd9h";
  };

  buildInputs = [ pkgconfig mtdev udev libevdev ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/libinput;
    description = "handles input devices in Wayland compositors and to provide a generic X.Org input driver";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ wkennington ];
  };
}
