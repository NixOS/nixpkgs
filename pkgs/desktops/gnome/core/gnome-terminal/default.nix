{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, python3
, libxml2
, gnome
, gitUpdater
, nautilus
, glib
, gtk4
, gtk3
, gsettings-desktop-schemas
, vte
, gettext
, which
, libuuid
, vala
, desktop-file-utils
, itstool
, wrapGAppsHook
, pcre2
, libxslt
, docbook-xsl-nons
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gnome-terminal";
  version = "3.48.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-terminal";
    rev = version;
    sha256 = "sha256-1t48JRESjAQubOmyK+QOhlp57iE5Ml0cqgy/2wjrLjE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    which
    libxml2
    libxslt
    glib # for glib-compile-schemas
    docbook-xsl-nons
    vala
    desktop-file-utils
    wrapGAppsHook
    pcre2
    python3
  ];

  buildInputs = [
    glib
    gtk4
    gtk3
    gsettings-desktop-schemas
    vte
    libuuid
    nautilus # For extension
  ];

  # Silly build system, it looks for dbus file from gnome-shell in the
  # installation tree of the package it is configuring.
  postPatch = ''
    substituteInPlace src/meson.build \
       --replace "gt_prefix / gt_dbusinterfacedir / 'org.gnome.ShellSearchProvider2.xml'" \
       "'${gnome.gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml'"

    patchShebangs \
      data/icons/meson_updateiconcache.py \
      data/meson_desktopfile.py \
      data/meson_metainfofile.py \
      src/meson_compileschemas.py
  '';

  passthru = {
    updateScript = gitUpdater {
      odd-unstable = true;
    };

    tests = {
      test = nixosTests.terminal-emulators.gnome-terminal;
    };
  };

  meta = with lib; {
    description = "The GNOME Terminal Emulator";
    homepage = "https://wiki.gnome.org/Apps/Terminal";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
  };
}
