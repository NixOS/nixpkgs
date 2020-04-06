{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  pname = "bwidget";
  version = "1.9.14";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/bwidget-${version}.tar.gz";
    sha256 = "0knlnpmwam74v0qa1h9gg4f32vzzz7ays2wbslflf51ilg7nw6jk";
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
