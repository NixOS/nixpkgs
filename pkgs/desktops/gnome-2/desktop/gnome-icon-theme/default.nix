{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, gtk2 }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme/3.12/${name}.tar.xz";
    sha256 = "0fjh9qmmgj34zlgxb09231ld7khys562qxbpsjlaplq2j85p57im";
  };

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk2 ];

  # remove a tree of dirs with no files within
  postInstall = '' rm -r "$out/share/locale" '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
