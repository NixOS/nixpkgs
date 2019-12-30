{ stdenv, fetchurl, python3 }:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.8.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "04a2klvii0in9ln8r85mk2cm73jq8ry2m3yzmf2z8xyjxzjcmlr0";
  };

  buildInputs = [ python3 ];

  meta = with stdenv.lib; {
    description = "Wrapper library for evdev devices";
    homepage = http://www.freedesktop.org/software/libevdev/doc/latest/index.html;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.amorsillo ];
  };
}
