{ fetchurl, fetchpatch, stdenv }:

stdenv.mkDerivation rec {
  name = "gsl-2.2";

  src = fetchurl {
    url = "mirror://gnu/gsl/${name}.tar.gz";
    sha256 = "1pyq2c0j91z955746myn29c89jwkd435s2cbj8ks2hpag6d0mr2d";
  };

  patches = [
    # ToDo: there might be more impurities than FMA support check
    ./disable-fma.patch # http://lists.gnu.org/archive/html/bug-gsl/2011-11/msg00019.html
  ];

  doCheck = stdenv.system != "i686-linux"; # https://lists.gnu.org/archive/html/bug-gsl/2015-11/msg00012.html

  meta = {
    description = "The GNU Scientific Library, a large numerical library";
    homepage = http://www.gnu.org/software/gsl/;
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      The GNU Scientific Library (GSL) is a numerical library for C
      and C++ programmers.  It is free software under the GNU General
      Public License.

      The library provides a wide range of mathematical routines such
      as random number generators, special functions and least-squares
      fitting.  There are over 1000 functions in total with an
      extensive test suite.
    '';
    platforms = stdenv.lib.platforms.unix;
  };
}
