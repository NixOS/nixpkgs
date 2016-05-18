{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.4.6";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "1lrja526iyg48yw6i0dxdhyj63q9gwbgvj6xk1hskxzrqyhf2akv";
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
