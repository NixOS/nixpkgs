{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "gsl-1.15";

  src = fetchurl {
    url = "mirror://gnu/gsl/${name}.tar.gz";
    sha256 = "18qf6jzz1r3mzb5qynywv4xx3z9g61hgkbpkdrhbgqh2g7jhgfc5";
  };

  # ToDo: there might be more impurities than FMA support check
  patches = [ ./disable-fma.patch ]; # http://lists.gnu.org/archive/html/bug-gsl/2011-11/msg00019.html
  patchFlags = "-p0";

  doCheck = true;

  meta = {
    description = "The GNU Scientific Library, a large numerical library";

    longDescription = ''
      The GNU Scientific Library (GSL) is a numerical library for C
      and C++ programmers.  It is free software under the GNU General
      Public License.

      The library provides a wide range of mathematical routines such
      as random number generators, special functions and least-squares
      fitting.  There are over 1000 functions in total with an
      extensive test suite.
    '';

    homepage = http://www.gnu.org/software/gsl/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
