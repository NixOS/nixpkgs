{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "gsl";
  version = "2.7";

  src = fetchurl {
    url = "mirror://gnu/gsl/${pname}-${version}.tar.gz";
    sha256 = "sha256-77vzeF2g5TA4vnkHUAYotGYVLbw8FzqH3hteui4jYCs=";
  };

  preConfigure = if (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.isDarwin) then ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '' else null;

  # do not let -march=skylake to enable FMA (https://lists.gnu.org/archive/html/bug-gsl/2011-11/msg00019.html)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isx86_64 "-mno-fma";

  # https://lists.gnu.org/archive/html/bug-gsl/2015-11/msg00012.html
  doCheck = stdenv.hostPlatform.system != "i686-linux";

  meta = {
    description = "The GNU Scientific Library, a large numerical library";
    homepage = "https://www.gnu.org/software/gsl/";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      The GNU Scientific Library (GSL) is a numerical library for C
      and C++ programmers.  It is free software under the GNU General
      Public License.

      The library provides a wide range of mathematical routines such
      as random number generators, special functions and least-squares
      fitting.  There are over 1000 functions in total with an
      extensive test suite.
    '';
    platforms = lib.platforms.unix;
  };
}
