{ lib, fetchurl, tcl }:

tcl.mkTclDerivation rec {
  pname = "tcllib";
  version = "1.20";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    sha256 = "0wax281h6ksz974a5qpfgf9y34lmlpd8i87lkm1w94ybbd3rgc73";
  };

  meta = {
    homepage = "https://sourceforge.net/projects/tcllib/";
    description = "Tcl-only library of standard routines for Tcl";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
}
