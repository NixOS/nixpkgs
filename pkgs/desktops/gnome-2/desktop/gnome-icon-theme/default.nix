{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk }:

stdenv.mkDerivation rec {
  #name = "gnome-icon-theme-3.4.0";
  name = "gnome-icon-theme-2.91.93";

  src = fetchurl {
    #url = "mirror://gnome/sources/gnome-icon-theme/3.4/${name}.tar.xz";
    url = "mirror://gnome/sources/gnome-icon-theme/2.91/${name}.tar.bz2";
    sha256 = "cc7f15e54e2640697b58c26e74cc3f6ebadeb4ef6622bffe9c1e6874cc3478d6";
  };
  
  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];
}
