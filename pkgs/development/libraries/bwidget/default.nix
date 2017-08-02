{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "bwidget-${version}";
  version = "1.9.10";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "025lmriaq4qqy99lh826wx2cnqqgxn7srz4m3q06bl6r9ch15hr6";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/lib/${passthru.libPrefix}"
    cp -R *.tcl lang images "$out/lib/${passthru.libPrefix}"
  '';

  passthru = {
    libPrefix = "bwidget${version}";
  };

  buildInputs = [ tcl ];

  meta = {
    homepage = http://tcl.activestate.com/software/tcllib/;
    description = "High-level widget set for Tcl/Tk";
    license = stdenv.lib.licenses.tcltk;
    platforms = stdenv.lib.platforms.linux;
  };
}
