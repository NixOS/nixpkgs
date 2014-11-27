{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2Python, perl, intltool, gettext, gnome3 }:

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${gnome3.version}/gtksourceview-${version}.tar.xz";
    sha256 = "b3c4a4f464fdb23ecc708a61c398aa3003e05adcd7d7223d48d9c04fe87524ad";
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
