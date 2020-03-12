{ stdenv, fetchurl, python3 }:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.9.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "17pb5375njb1r05xmk0r57a2j986ihglh2n5nqcylbag4rj8mqg7";
  };

  buildInputs = [ python3 ];

  meta = with stdenv.lib; {
    description = "Wrapper library for evdev devices";
    homepage = "http://www.freedesktop.org/software/libevdev/doc/latest/index.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.amorsillo ];
  };
}
