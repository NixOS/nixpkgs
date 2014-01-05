{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "bwidget-${version}";
  version = "1.9.7";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "1z2z77l41g01ra7v716c0q3x8s2kx30l4p1kf21ma8bdqa98arp6";
  };

  dontBuild = true;

  installPhase = ''
    ensureDir "$out/lib/${passthru.libPrefix}"
    cp -R *.tcl lang images "$out/lib/${passthru.libPrefix}"
  '';

  passthru = {
    libPrefix = "bwidget${version}";
  };

  buildInputs = [ tcl ];

  meta = {
    homepage = "http://tcl.activestate.com/software/tcllib/";
    description = "High-level widget set for Tcl/Tk";
    license = stdenv.lib.licenses.tcltk;
  };
}
