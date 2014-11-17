{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "bwidget-${version}";
  version = "1.9.8";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "055kpl3ghznk028jnhzsa3p48qgipckfzn2liwq932crxviicl2l";
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
    homepage = "http://tcl.activestate.com/software/tcllib/";
    description = "High-level widget set for Tcl/Tk";
    license = stdenv.lib.licenses.tcltk;
  };
}
