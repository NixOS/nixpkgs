{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.5.8";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0vac7n1miqdprikq4g63vsk681q8v416r0nbh2xai7b08qgdi0v0";
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
