{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  pname = "tcllib";
  version = "1.20";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    sha256 = "0wax281h6ksz974a5qpfgf9y34lmlpd8i87lkm1w94ybbd3rgc73";
  };

  passthru = {
    libPrefix = "tcllib${version}";
  };

  buildInputs = [ tcl ];

  meta = {
    homepage = https://sourceforge.net/projects/tcllib/;
    description = "Tcl-only library of standard routines for Tcl";
    license = stdenv.lib.licenses.tcltk;
    platforms = stdenv.lib.platforms.unix;
  };
}
