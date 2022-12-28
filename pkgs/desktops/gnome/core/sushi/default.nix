{ lib, stdenv
, fetchurl
, pkg-config
, meson
, gettext
, gobject-introspection
, glib
, gnome
, gtksourceview4
, gjs
, libsoup_3
, webkitgtk_4_1
, icu
, wrapGAppsHook
, gst_all_1
, gdk-pixbuf
, librsvg
, gtk3
, harfbuzz
, ninja
, libepoxy
}:

stdenv.mkDerivation rec {
  pname = "sushi";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "V4SFJhSasceE+5L7yTTDUU/lIqumSdXZ/t7H4bFHUns=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    gnome.evince
    icu
    harfbuzz
    gjs
    gtksourceview4
    gdk-pixbuf
    librsvg
    libsoup_3
    webkitgtk_4_1
    libepoxy
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
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
    updateScript = gnome.updateScript {
      packageName = "sushi";
      attrPath = "gnome.sushi";
    };
  };

  meta = with lib; {
    homepage = "https://en.wikipedia.org/wiki/Sushi_(software)";
    description = "A quick previewer for Nautilus";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
