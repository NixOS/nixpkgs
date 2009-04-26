{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "gsl-1.12";

  src = fetchurl {
    url = "mirror://gnu/gsl/${name}.tar.gz";
    sha256 = "1fdpqw981gcc0wkvcacm16mrrsq5f4jdq395zk59lxjcsa492092";
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
  };
}
