{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0h54ym5rsmicl4gx7gcdaifpyndakbl38c5dcxgr27f0cy0635a1";
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
