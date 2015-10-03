{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2Python, perl, intltool, gettext, gnome3 }:

stdenv.mkDerivation rec {
  name = "gtksourceview-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${gnome3.version}/${name}.tar.xz";
    sha256 = "030v7x1dmx5blqi9jcknsjd91jppbpl7f4z69k8c8kklr939i7k6";
  };

  propagatedBuildInputs = [ gtk3 ];

  buildInputs = [ pkgconfig atk cairo glib pango
                  libxml2Python perl intltool gettext ];

  preBuild = ''
    substituteInPlace gtksourceview/gtksourceview-utils.c --replace "@NIX_SHARE_PATH@" "$out/share"
  ''; 

  patches = [ ./nix_share_path.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
