{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.5.7";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "08nl3p6226k51zph52fhilxvi3b31spp6fz8szzrglzhl8vrxrd1";
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
