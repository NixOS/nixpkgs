{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.3.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0hr6xjp7vcnr7lnr1il03235rcslqb95yv7j88qh51q0bwcpcz2b";
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
