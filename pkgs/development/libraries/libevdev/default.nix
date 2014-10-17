{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.3";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0iil4pnla0kjdx52ay7igq65sx32sjbzn1wx9q3v74m5g7712m16";
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
