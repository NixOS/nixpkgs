{ stdenv, fetchurl, pkgconfig, file, intltool, gobject-introspection, glib
, clutter-gtk, clutter-gst, gnome3, aspell, hspell, gtksourceview, gjs
, webkitgtk, libmusicbrainz5, icu, wrapGAppsHook, gst_all_1
, gdk_pixbuf, librsvg, gtk3, harfbuzz }:

stdenv.mkDerivation rec {
  name = "sushi-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0zpaiw5r734fky3zq95a6szwn7srbkpixajqg2xvdivhhx4mbnnj";
  };

  nativeBuildInputs = [ pkgconfig file intltool gobject-introspection wrapGAppsHook ];
  buildInputs = [
    glib gtk3 gnome3.evince icu harfbuzz
    clutter-gtk clutter-gst gjs gtksourceview gdk_pixbuf
    librsvg libmusicbrainz5 webkitgtk
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    # cannot find -laspell, -lhspell
    aspell hspell
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "sushi";
      attrPath = "gnome3.sushi";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://en.wikipedia.org/wiki/Sushi_(software)";
    description = "A quick previewer for Nautilus";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
