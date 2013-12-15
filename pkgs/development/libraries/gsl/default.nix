{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "gsl-1.16";

  src = fetchurl {
    url = "mirror://gnu/gsl/${name}.tar.gz";
    sha256 = "0lrgipi0z6559jqh82yx8n4xgnxkhzj46v96dl77hahdp58jzg3k";
  };

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

    maintainers = [ ];
  };
}
