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
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1zcr8wi5bgvvpb5ha1v96aiaz4vqqrsn6cvvalwzah6am85k78m8";
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
