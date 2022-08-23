{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, python3
, libxml2
, gnome
, dconf
, nautilus
, glib
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
  version = "3.44.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "+28g7h/yMamq7asT1dxuWmTJVXESJISLeQCG6IlZ03s=";
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
    gtk3
    gsettings-desktop-schemas
    vte
    libuuid
    dconf
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
      src/meson_compileschemas.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-terminal";
      attrPath = "gnome.gnome-terminal";
    };
  };

  passthru.tests.test = nixosTests.terminal-emulators.gnome-terminal;

  meta = with lib; {
    description = "The GNOME Terminal Emulator";
    homepage = "https://wiki.gnome.org/Apps/Terminal";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
  };
}
