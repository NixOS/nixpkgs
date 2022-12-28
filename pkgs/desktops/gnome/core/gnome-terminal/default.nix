{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, python3
, libxml2
, gnome
, nix-update-script
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
  version = "3.47.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-terminal";
    rev = version;
    sha256 = "sha256-CriI1DtDBeujaz0HtXCyzoGxnas7NmD6EMQ+gLph3E4=";
  };

  patches = [
    # Fix Nautilus extension build.
    # https://gitlab.gnome.org/GNOME/gnome-terminal/-/issues/7916
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-terminal/-/commit/614ea99b16fb09e10341fc6ccf5e115ac3f93caf.patch";
      sha256 = "K7JHPfXywF3QSjSjyUnNZ11/ed+QXHQ47i135QBMIR8=";
    })
  ];

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
      src/meson_compileschemas.py
  '';

  passthru = {
    updateScript = nix-update-script { };

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
