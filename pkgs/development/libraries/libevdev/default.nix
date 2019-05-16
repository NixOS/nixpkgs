{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.6.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "057qdrwbhql2lvr4kxljk3yqjsmh65hyrfbr2b681nc7b635q07m";
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
