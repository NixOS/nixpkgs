{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2Python, perl, intltool, gettext, gnome3 }:

stdenv.mkDerivation rec {
  name = "gtksourceview-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${gnome3.version}/${name}.tar.xz";
    sha256 = "068d3cks7vhkhs5j4h76kqh5pfc3nkkrh9xlkx805fk5kdfy56jd";
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
