{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.4.3";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "16wn4zb0wrqvzmgcgiafndvwh4akzdvjzgkj128fkc3qzlk8nh8w";
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
