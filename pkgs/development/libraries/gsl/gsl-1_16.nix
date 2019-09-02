{ fetchurl, fetchpatch, stdenv }:

stdenv.mkDerivation rec {
  name = "gsl-1.16";

  src = fetchurl {
    url = "mirror://gnu/gsl/${name}.tar.gz";
    sha256 = "0lrgipi0z6559jqh82yx8n4xgnxkhzj46v96dl77hahdp58jzg3k";
  };

  # do not let -march=skylake to enable FMA (https://lists.gnu.org/archive/html/bug-gsl/2011-11/msg00019.html)
  NIX_CFLAGS_COMPILE = stdenv.lib.optional stdenv.isx86_64 "-mno-fma";

  patches = [
    (fetchpatch {
      name = "bug-39055.patch";
      url = "https://git.savannah.gnu.org/cgit/gsl.git/patch/?id=9cc12d";
      sha256 = "1bmrmihi28cly9g9pq54kkix2jy59y7cd7h5fw4v1c7h5rc2qvs8";
    })
  ];

  doCheck = true;

  meta = {
    description = "The GNU Scientific Library, a large numerical library";
    homepage = https://www.gnu.org/software/gsl/;
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
    # Failing "eigen" tests on aarch64.
    badPlatforms = [ "aarch64-linux" ];
  };
}
