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
    ensureDir "$out/tcltk"
    cp -R *.tcl lang images "$out/tcltk/"
  '';

  buildInputs = [tcl];
}
