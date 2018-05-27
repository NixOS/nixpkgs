{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.5.9";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "0xca343ff12wh6nsq76r0nbsfrm8dypjrzm4fqz9vv9v8i8kfrp1";
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
