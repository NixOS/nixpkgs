{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.6.901";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0jqz4jzcqxa8bwzry952c0h69w5h8jm63wa59gnhn17j7ayvhzri";
  };

  buildInputs = [ python ];

  meta = with stdenv.lib; {
    description = "Wrapper library for evdev devices";
    homepage = http://www.freedesktop.org/software/libevdev/doc/latest/index.html;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.amorsillo ];
  };
}
