{ stdenv, fetchurl, python }:
stdenv.mkDerivation rec {
  version = "1.2"; 
  name = "libevdev-${version}";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/libevdev-${version}.tar.xz";
    sha256 = "0h54ym5rsmicl4gx7gcdaifpyndakbl38c5dcxgr27f0cy0635a1";
  };

  buildInputs = [ python ];

  meta = {
    homepage = http://www.freedesktop.org/software/libevdev/doc/latest/index.html; 
    description = "libevdev is a wrapper library for evdev devices";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainer = with stdenv.lib.maintainers; [ amorsillo ];
  };
}
