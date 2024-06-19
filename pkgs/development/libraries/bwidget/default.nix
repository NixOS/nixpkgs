{ lib, fetchurl, tcl, tk }:

tcl.mkTclDerivation rec {
  pname = "bwidget";
  version = "1.9.16";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "sha256-v+ADY3S4QpPSNiCn9t2oZXGBPQx63+2YPB8zflzoGuA=";
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
