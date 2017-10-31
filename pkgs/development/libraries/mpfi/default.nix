{stdenv, fetchurl, mpfr}:
stdenv.mkDerivation rec {
  name = "mpfi-${version}";
  version = "1.5.1";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/30129/mpfi-${version}.tar.bz2";
    sha256 = "0vk9jfcfiqda0zksg1ffy36pdznpng9b4nl7pfzpz9hps4v6bk1z";
  };
  buildInputs = [mpfr];
  meta = {
    inherit version;
    description = ''A multiple precision interval arithmetic library based on MPFR'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
