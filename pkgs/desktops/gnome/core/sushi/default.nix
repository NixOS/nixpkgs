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
, webkitgtk_4_1
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
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "m3UlaQzkNmJO+gpgV3NJNDLNDva49GSYLouETtqYmO4=";
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
    webkitgtk_4_1
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
