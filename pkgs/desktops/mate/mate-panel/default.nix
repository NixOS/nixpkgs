{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, glib
, libwnck
, librsvg
, libxml2
, dconf
, gtk3
, mate
, hicolor-icon-theme
, gobject-introspection
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-panel";
  version = "1.26.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "rsT5jInFnnbMBlbtBILx2CkS9N7MZg8hyNAE5JPgVBA=";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    itstool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    libwnck
    librsvg
    libxml2
    gtk3
    dconf
    mate.libmateweather
    mate.mate-desktop
    mate.mate-menus
    hicolor-icon-theme
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Workspace switcher settings, works only when passed after gtk3 schemas in the wrapper for some reason
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath mate.marco}"
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
