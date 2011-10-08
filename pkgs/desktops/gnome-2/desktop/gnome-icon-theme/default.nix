{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-2.28.0";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme/2.28/${name}.tar.bz2";
    sha256 = "111q1yijm8mjvz600nfa49gbjz4988vpfv74jcknfng0k92vvv1i";
  };
  
  buildInputs = [ pkgconfig intltool iconnamingutils ];
}
