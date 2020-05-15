{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  pname = "bwidget";
  version = "1.9.14";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "0wm6hk3rnqhnn2cyw24drqwbfnysp6jyfi8lc1vih5k704a955lf";
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
    homepage = "https://sourceforge.net/projects/tcllib";
    description = "High-level widget set for Tcl/Tk";
    license = stdenv.lib.licenses.tcltk;
    platforms = stdenv.lib.platforms.linux;
  };
}
