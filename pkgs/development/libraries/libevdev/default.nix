{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.5.6";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "1256ypz93039n6km4macg158fpmjgylhmcmk20pnklxicsfpxv7c";
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
