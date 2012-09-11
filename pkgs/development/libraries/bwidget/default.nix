{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "bwidget-${version}";
  version = "1.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "1njssjjvfalsfh37prkxwqi4hf0zj1d54qzggvjwpzkm424jjcii";
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
    description = "The BWidget toolkit is a high-level widget set for Tcl/Tk.";
    license = stdenv.lib.licenses.tcltk;
  };
}
