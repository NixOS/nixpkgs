{ stdenv, lib, fetchurl, bzip2, zlib }:

stdenv.mkDerivation rec {
  pname = "cfitsio";
  version = "4.1.0";

  src = fetchurl {
    url = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-${version}.tar.gz";
    sha256 = "sha256-s2fGldKDGVjnFmkhw7NW1d+lGx7O5QW5dBa6OdG2wXo=";
  };

  buildInputs = [ bzip2 zlib ];

  patches = [ ./darwin-rpath-universal.patch ];

  configureFlags = [ "--with-bzip2=${bzip2.out}" "--enable-reentrant" ];

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
    changelog = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/docs/changes.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ xbreak hjones2199 ];
    platforms = with platforms; linux ++ darwin;
  };
}
