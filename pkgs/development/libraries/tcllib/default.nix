{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "tcllib-${version}";
  version = "1.19";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    sha256 = "173abxaazdmf210v651708ab6h7xhskvd52krxk6ifam337qgzh1";
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
