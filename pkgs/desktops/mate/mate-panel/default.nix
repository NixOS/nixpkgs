{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, glib
, gnome
, gtk-layer-shell
, gtk3
, libmateweather
, libwnck
, librsvg
, libxml2
, dconf
, mate-desktop
, mate-menus
, hicolor-icon-theme
, wayland
, gobject-introspection
, wrapGAppsHook3
, marco
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-panel";
  version = "1.28.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "UTPGT1lpro7uvm6LukUN6nkssL4G2a4cNuhWnS+FJLo=";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    itstool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk-layer-shell
    libmateweather
    libwnck
    librsvg
    libxml2
    dconf
    mate-desktop
    mate-menus
    hicolor-icon-theme
    wayland
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    # See https://github.com/mate-desktop/mate-panel/issues/1402
    # This is propagated for mate_panel_applet_settings_new and applet's wrapGAppsHook3
    gnome.dconf-editor
  ];

  # Needed for Wayland support.
  configureFlags = [ "--with-in-process-applets=all" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Workspace switcher settings, works only when passed after gtk3 schemas in the wrapper for some reason
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath marco}"
    )
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "The MATE panel";
    homepage = "https://github.com/mate-desktop/mate-panel";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
