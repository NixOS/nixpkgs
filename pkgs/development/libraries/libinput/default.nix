{ stdenv, fetchurl, pkgconfig, mtdev, udev, libevdev }:

stdenv.mkDerivation rec {
  name = "libinput-0.7.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libinput/${name}.tar.xz";
    sha256 = "17jps5iz8kvhbgbd0h436grzb6fbjwf9k4qjcja96jjyzrd4i7qj";
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
