{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "tcllib-${version}";
  version = "1.15";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    sha256 = "1zdzaqdpxljsaabgknq3paakgs262qy255ib4p329knsv608jc3d";
  };

  passthru = {
    libPrefix = "tcllib${version}";
  };

  buildInputs = [ tcl ];

  meta = {
    homepage = "http://tcl.activestate.com/software/tcllib/";
    description = "Tcl-only library of standard routines for Tcl";
    license = stdenv.lib.licenses.tcltk;
    platforms = stdenv.lib.platforms.unix;
  };
}
