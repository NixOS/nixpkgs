{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libevdev-1.4.4";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libevdev/${name}.tar.xz";
    sha256 = "1aa5pj2ivhvpxcbvgh80ghmzpkwyahw9a2bxi7sjhvkakcv7k6gd";
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
