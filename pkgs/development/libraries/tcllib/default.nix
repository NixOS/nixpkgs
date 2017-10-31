{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "tcllib-${version}";
  version = "1.18";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    sha256 = "05dmrk9qsryah2n17z6z85dj9l9lfyvnsd7faw0p9bs1pp5pwrkj";
  };

  passthru = {
    libPrefix = "tcllib${version}";
  };

  buildInputs = [ tcl ];

  meta = {
    homepage = http://tcl.activestate.com/software/tcllib/;
    description = "Tcl-only library of standard routines for Tcl";
    license = stdenv.lib.licenses.tcltk;
    platforms = stdenv.lib.platforms.unix;
  };
}
