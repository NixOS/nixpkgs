{ lib, fetchurl, tcl, tk }:

tcl.mkTclDerivation rec {
  pname = "bwidget";
  version = "1.9.14";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "0wm6hk3rnqhnn2cyw24drqwbfnysp6jyfi8lc1vih5k704a955lf";
  };

  dontBuild = true;
  propagatedBuildInputs = [ tk ];

  installPhase = ''
    mkdir -p "$out/lib/bwidget${version}"
    cp -R *.tcl lang images "$out/lib/bwidget${version}"
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/tcllib";
    description = "High-level widget set for Tcl/Tk";
    maintainers = with lib.maintainers; [ agbrooks ];
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
}
