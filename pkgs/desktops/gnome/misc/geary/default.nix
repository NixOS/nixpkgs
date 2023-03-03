{ lib
, stdenv
, fetchurl
, pkg-config
, gtk3
, vala
, enchant2
, wrapGAppsHook
, meson
, ninja
, desktop-file-utils
, gnome-online-accounts
, gsettings-desktop-schemas
, adwaita-icon-theme
, libpeas
, libsecret
, gmime3
, isocodes
, icu
, libxml2
, gettext
, sqlite
, gcr
, json-glib
, itstool
, libgee
, gnome
, webkitgtk_4_1
, python3
, gnutls
, cacert
, xvfb-run
, glibcLocales
, dbus
, shared-mime-info
, libunwind
, folks
, glib-networking
, gobject-introspection
, gspell
, appstream-glib
, libstemmer
, libytnef
, libhandy
, gsound
}:

stdenv.mkDerivation rec {
  pname = "geary";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "SJFm+H3Z0pAR9eW3lpTyWItHP34ZHFnOkBPIyODjY+c=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    enchant2
    folks
    gcr
    glib-networking
    gmime3
    gnome-online-accounts
    gsettings-desktop-schemas
    gsound
    gspell
    gtk3
    isocodes
    icu
    json-glib
    libgee
    libhandy
    libpeas
    libsecret
    libunwind
    libstemmer
    libytnef
    sqlite
    webkitgtk_4_1
  ];

  nativeCheckInputs = [
    dbus
    gnutls # for certtool
    cacert # trust store for glib-networking
    xvfb-run
    glibcLocales # required by Geary.ImapDb.DatabaseTest/utf8_case_insensitive_collation
  ];

  mesonFlags = [
    "-Dprofile=release"
    "-Dcontractor=enabled" # install the contractor file (Pantheon specific)
  ];

  # NOTE: Remove `build-auxyaml_to_json.py` when no longer needed, see:
  # https://gitlab.gnome.org/GNOME/geary/commit/f7f72143e0f00ca5e0e6a798691805c53976ae31#0cc1139e3347f573ae1feee5b73dbc8a8a21fcfa
  postPatch = ''
    chmod +x build-aux/git_version.py

    patchShebangs build-aux/git_version.py

    chmod +x desktop/geary-attach
  '';

  # Some tests time out.
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    NO_AT_BRIDGE=1 \
    GIO_EXTRA_MODULES=$GIO_EXTRA_MODULES:${glib-networking}/lib/gio/modules \
    HOME=$TMPDIR \
    XDG_DATA_DIRS=$XDG_DATA_DIRS:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${shared-mime-info}/share:${folks}/share/gsettings-schemas/${folks.name} \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test -v --no-stdsplit

    runHook postCheck
  '';

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Geary";
    description = "Mail client for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
