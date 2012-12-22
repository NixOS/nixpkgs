{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "tcllib-${version}";
  version = "1.14";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${version}.tar.gz";
    sha256 = "11052fgfmv9vyswzjjgfvh3pi0k3fnfnl9ri6nl4vc6f6z5ry56x";
  };

  passthru = {
    libPrefix = "tcllib${version}";
  };

  buildInputs = [ tcl ];

  meta = {
    homepage = "http://tcl.activestate.com/software/tcllib/";
    description = "Tcl-only library of standard routines for Tcl";
    license = stdenv.lib.licenses.tcltk;
  };
}
