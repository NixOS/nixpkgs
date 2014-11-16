{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "libcaca-0.99.beta19";

  src = fetchurl {
    url = "http://caca.zoy.org/files/libcaca/${name}.tar.gz";
    sha256 = "1x3j6yfyxl52adgnabycr0n38j9hx2j74la0hz0n8cnh9ry4d2qj";
  };

  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";

  propagatedBuildInputs = [ncurses];

  meta = {
    homepage = http://libcaca.zoy.org/;
    description = "A graphics library that outputs text instead of pixels";
    license = stdenv.lib.licenses.wtfpl;
  };
}
