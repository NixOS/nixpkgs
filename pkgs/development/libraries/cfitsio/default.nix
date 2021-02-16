{ fetchurl, lib, stdenv, bzip2 }:
stdenv.mkDerivation rec {
  pname = "cfitsio";
  version = "3.49";

  src = fetchurl {
    url = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-${version}.tar.gz";
    sha256 = "1cyl1qksnkl3cq1fzl4dmjvkd6329b57y9iqyv44wjakbh6s4rav";
  };

  buildInputs = [ bzip2 ];

  patches = [ ./darwin-rpath-universal.patch ];

  configureFlags = [ "--with-bzip2=${bzip2.out}" ];

  hardeningDisable = [ "format" ];

  # Shared-only build
  buildFlags = [ "shared" ];
  postPatch = '' sed -e '/^install:/s/libcfitsio.a //' -e 's@/bin/@@g' -i Makefile.in
   '';

  meta = with lib; {
    homepage = "https://heasarc.gsfc.nasa.gov/fitsio/";
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
    license = licenses.mit;
    maintainers = [ maintainers.xbreak ];
    platforms = with platforms; linux ++ darwin;
  };
}
