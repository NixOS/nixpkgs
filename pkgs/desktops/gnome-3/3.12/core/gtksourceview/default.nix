{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2Python, perl, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/3.12/gtksourceview-${version}.tar.xz";
    sha256 = "62a31eee00f633d7959efb7eec44049ebd0345d670265853dcd21c057f3f30ad";
  };

  buildInputs = [ pkgconfig atk cairo glib gtk3 pango
                  libxml2Python perl intltool gettext ];

  preBuild = ''
    substituteInPlace gtksourceview/gtksourceview-utils.c --replace "@NIX_SHARE_PATH@" "$out/share"
  ''; 

  patches = [ ./nix_share_path.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
