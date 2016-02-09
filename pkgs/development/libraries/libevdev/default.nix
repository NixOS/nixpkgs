{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.4.5";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "07faqb47c7sjl25rc788cbslyiv5ijky0jc4g6312qz0hv55h779";
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
