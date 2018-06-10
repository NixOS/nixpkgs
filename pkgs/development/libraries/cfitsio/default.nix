{ fetchurl, stdenv }:

 stdenv.mkDerivation {
  name = "cfitsio-3.430";

  src = fetchurl {
    url = "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3430.tar.gz";
    sha256 = "07fghxh5fl8nqk3q0dh8rvc83npnm0hisxzcj16a6r7gj5pmp40l";
  };

  patches = [ ./darwin-curl-config.patch ./darwin-rpath-universal.patch ];

  # Shared-only build
  buildFlags = "shared";
  postPatch = '' sed -e '/^install:/s/libcfitsio.a //' -e 's@/bin/@@g' -i Makefile.in
   '';

  meta = with stdenv.lib; {
    homepage = https://heasarc.gsfc.nasa.gov/fitsio/;
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
    platforms = with platforms; linux ++ darwin;
  };
}
