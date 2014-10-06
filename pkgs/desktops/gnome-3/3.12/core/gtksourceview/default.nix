{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2Python, perl, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "3.12.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/3.12/gtksourceview-${version}.tar.xz";
    sha256 = "1xzmw9n9zbkaasl8xi7s5h49wiv5dq4qf8hr2pzjkack3ai5j6gk";
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
