{ fetchurl, stdenv }:

stdenv.mkDerivation {
  name = "cfitsio-3.21";

  src = fetchurl {
    url = ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3210.tar.gz;
    sha256 = "1ffr3p5dy2b1vj9j4li5zf22naavi9wcxsvqy236fc0ykfyip96i";
  };

  # Shared-only build
  buildFlags = "shared";
  patchPhase =
   '' sed -e '/^install:/s/libcfitsio.a //' -e 's@/bin/@@g' -i Makefile.in
   '';

  meta = {
    homepage = http://heasarc.gsfc.nasa.gov/fitsio/;

    description = "Library for reading and writing FITS data files";

    longDescription =
      '' CFITSIO is a library of C and Fortran subroutines for reading and
         writing data files in FITS (Flexible Image Transport System) data
         format.  CFITSIO provides simple high-level routines for reading and
         writing FITS files that insulate the programmer from the internal
         complexities of the FITS format.  CFITSIO also provides many
         advanced features for manipulating and filtering the information in
         FITS files.
      '';

    # Permissive BSD-style license.
    license = "permissive";
    platforms = stdenv.lib.platforms.unix;
  };
}
