{ stdenv
, fetchurl
, pkgconfig
, meson
, gettext
, gobject-introspection
, glib
, clutter-gtk
, clutter-gst
, gnome3
, gtksourceview4
, gjs
, webkitgtk
, libmusicbrainz5
, icu
, wrapGAppsHook
, gst_all_1
, gdk-pixbuf
, librsvg
, gtk3
, harfbuzz
, ninja
, epoxy
}:

stdenv.mkDerivation rec {
  pname = "sushi";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0vlqqk916dymv4asbyvalp1m096a5hh99nx23i4xavzvgygh4h2h";
  };

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    gettext
    gobject-introspection
    wrapGAppsHook
  ];
  buildInputs = [
    glib
    gtk3
    gnome3.evince
    icu
    harfbuzz
    clutter-gtk
    clutter-gst
    gjs
    gtksourceview4
    gdk-pixbuf
    librsvg
    libmusicbrainz5
    webkitgtk
    epoxy
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  # See https://github.com/NixOS/nixpkgs/issues/31168
  postInstall = ''
    for file in $out/libexec/org.gnome.NautilusPreviewer
    do
      sed -e $"2iimports.package._findEffectiveEntryPointName = () => \'$(basename $file)\' " \
        -i $file
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "sushi";
      attrPath = "gnome3.sushi";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://en.wikipedia.org/wiki/Sushi_(software)";
    description = "A quick previewer for Nautilus";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
