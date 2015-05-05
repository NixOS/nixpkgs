{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.4.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "11dfiz7pkb2jbavr1ba8phn86qavvgf1xwlxmfs69mqxlz4x6yai";
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
