{ stdenv, fetchurl, pkgconfig, gtk3, vala, enchant2, wrapGAppsHook, meson, ninja
, desktop-file-utils, gnome-online-accounts, gsettings-desktop-schemas, adwaita-icon-theme
, libpeas, libsecret, gmime3, isocodes, libxml2, gettext, fetchpatch
, sqlite, gcr, json-glib, itstool, libgee, gnome3, webkitgtk, python3
, xvfb_run, dbus, shared-mime-info, libunwind, folks, glib-networking
, gobject-introspection, gspell, appstream-glib, libytnef, libhandy }:

stdenv.mkDerivation rec {
  pname = "geary";
  version = "3.36.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "09l2lbcn3ar3scw6iylmdqi1lhpb408iqs6056d0wzx2l9nkmqis";
  };

  nativeBuildInputs = [
    desktop-file-utils gettext itstool libxml2 meson ninja
    pkgconfig vala wrapGAppsHook python3 appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    adwaita-icon-theme enchant2 gcr gmime3 gnome-online-accounts
    gsettings-desktop-schemas gtk3 isocodes json-glib libpeas
    libgee libsecret sqlite webkitgtk glib-networking
    libunwind folks gspell libytnef libhandy
  ];

  checkInputs = [ xvfb_run dbus ];

  mesonFlags = [
    "-Dcontractor=true" # install the contractor file (Pantheon specific)
  ];

  patches = [
    # Longer timeout for client test.
    (fetchpatch {
      url = "https://salsa.debian.org/gnome-team/geary/raw/04be1e058a2e65075dd8cf8843d469ee45a9e09a/debian/patches/Bump-client-test-timeout-to-300s.patch";
      sha256 = "1zvnq8bgla160531bjdra8hcg15mp8r1j1n53m1xfgm0ssnj5knx";
    })
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

  # FIXME: fix tests
  doCheck = false;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS=:$XDG_DATA_DIRS:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${shared-mime-info}/share \
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
