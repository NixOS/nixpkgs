{ stdenv, fetchurl, pkgconfig, mtdev, udev, libevdev }:

stdenv.mkDerivation rec {
  name = "libinput-0.10.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libinput/${name}.tar.xz";
    sha256 = "0h8lbhhxb5020bhdblxp1pkapy4bchjj3l44fxabz9pi1zw03q2c";
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
