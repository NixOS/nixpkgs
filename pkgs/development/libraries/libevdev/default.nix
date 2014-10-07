{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.2.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0f0yvfg9bwl5xgpcz4kj37l5awcd4l9c78ghxiq3w32gwaz25ibw";
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
