{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.7.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0sg3lbjn68qaq3yz2k735h29kaf3fmx7b5m1x7rm2fnhn7rf3nqi";
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
