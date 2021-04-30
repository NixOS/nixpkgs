{ lib, fetchurl, tcl }:

let
  version = "1.9.14";
  libPrefix = "bwidget${version}";
in tcl.mkTclDerivation {
  pname = "bwidget";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "0wm6hk3rnqhnn2cyw24drqwbfnysp6jyfi8lc1vih5k704a955lf";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/lib/${libPrefix}"
    cp -R *.tcl lang images "$out/lib/${libPrefix}"
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/tcllib";
    description = "High-level widget set for Tcl/Tk";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.linux;
  };
}
