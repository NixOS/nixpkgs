{ fetchurl, stdenv

# Optional dependencies
, bzip2 ? null }:

stdenv.mkDerivation rec {
  name = "cfitsio-${version}";
  version = "3.450";

  src = fetchurl {
    url = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio${builtins.replaceStrings ["."] [""] version}.tar.gz";
    sha256 = "0bmrkw6w65zb0k3mszaaqy1f4zjm2hl7njww74nb5v38wvdi4q5z";
  };

  buildInputs = [ bzip2 ];

  patches = [ ./darwin-curl-config.patch ./darwin-rpath-universal.patch ];

  configureFlags = stdenv.lib.optional (bzip2 != null) "--with-bzip2=${bzip2.out}";

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
    license = licenses.mit;
    maintainers = [ maintainers.xbreak ];
    platforms = with platforms; linux ++ darwin;
  };
}
