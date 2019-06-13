{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "bwidget-${version}";
  version = "1.9.13";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "109s81hzd86vwzs18v4s03asn3l395wl64kd311045p7h0ig9n3n";
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
