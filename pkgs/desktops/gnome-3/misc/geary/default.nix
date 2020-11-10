{ stdenv
, fetchurl
, fetchpatch
, pkgconfig
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
, libxml2
, gettext
, sqlite
, gcr
, json-glib
, itstool
, libgee
, gnome3
, webkitgtk
, python3
, gnutls
, cacert
, xvfb_run
, glibcLocales
, dbus
, shared-mime-info
, libunwind
, folks
, glib-networking
, gobject-introspection
, gspell
, appstream-glib
, libytnef
, libhandy
, gsound
}:

stdenv.mkDerivation rec {
  pname = "geary";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "04p8fjkz4xp5afp0ld1m09pnv0zkcx51l7hf23amfrjkk0kj2bp7";
  };

  patches = [
    # Longer timeout for client test.
    ./Bump-client-test-timeout-to-300s.patch
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    libxml2
    meson
    ninja
    pkgconfig
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
    json-glib
    libgee
    libhandy
    libpeas
    libsecret
    libunwind
    libytnef
    sqlite
    webkitgtk
  ];

  checkInputs = [
    dbus
    gnutls # for certtool
    cacert # trust store for glib-networking
    xvfb_run
    glibcLocales # required by Geary.ImapDb.DatabaseTest/utf8_case_insensitive_collation
  ];

  mesonFlags = [
    "-Dcontractor=true" # install the contractor file (Pantheon specific)
  ];

  # NOTE: Remove `build-auxyaml_to_json.py` when no longer needed, see:
  # https://gitlab.gnome.org/GNOME/geary/commit/f7f72143e0f00ca5e0e6a798691805c53976ae31#0cc1139e3347f573ae1feee5b73dbc8a8a21fcfa
  postPatch = ''
    chmod +x build-aux/post_install.py build-aux/git_version.py

    patchShebangs build-aux/post_install.py build-aux/git_version.py

    chmod +x build-aux/yaml_to_json.py
    patchShebangs build-aux/yaml_to_json.py

    chmod +x desktop/geary-attach
  '';

  doCheck = true;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    GIO_EXTRA_MODULES=$GIO_EXTRA_MODULES:${glib-networking}/lib/gio/modules \
    XDG_DATA_DIRS=$XDG_DATA_DIRS:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${shared-mime-info}/share:${folks}/share/gsettings-schemas/${folks.name} \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test -v --no-stdsplit
  '';

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Geary";
    description = "Mail client for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
