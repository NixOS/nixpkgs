{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "bwidget-${version}";
  version = "1.9.12";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "0qrj8k4zzrnhwgdn5dpa6j0q5j739myhwn60ssnqrzq77sljss1g";
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
    homepage = https://sourceforge.net/projects/tcllib;
    description = "High-level widget set for Tcl/Tk";
    license = stdenv.lib.licenses.tcltk;
    platforms = stdenv.lib.platforms.linux;
  };
}
