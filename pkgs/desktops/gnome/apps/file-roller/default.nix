{ lib
, stdenv
, fetchurl
, fetchpatch
, desktop-file-utils
, gettext
, glibcLocales
, itstool
, libxml2
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, cpio
, file
, glib
, gnome
, gtk3
, json-glib
, libarchive
, libnotify
, nautilus
, pantheon
, unzip
, withPantheon ? false
}:

stdenv.mkDerivation rec {
  pname = "file-roller";
  version = "3.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "039w1dcpa5ypmv6sm634alk9vbcdkyvy595vkh5gn032jsiqca2a";
  };

  patches = lib.optionals withPantheon [
    # Make this respect dark mode settings from Pantheon
    # https://github.com/elementary/fileroller/
    (fetchpatch {
      url = "https://raw.githubusercontent.com/elementary/fileroller/f183eac36c68c9c9441e72294d4e305cf5fe36ed/fr-application-prefers-color-scheme.patch";
      sha256 = "sha256-d/sqf4Oen9UrzYqru7Ck15o/6g6WfxRDH/iAGFXgYAA=";
    })
  ];

  LANG = "en_US.UTF-8"; # postinstall.py

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glibcLocales
    itstool
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    cpio
    file
    glib
    gnome.adwaita-icon-theme
    gtk3
    json-glib
    libarchive
    libnotify
    nautilus
  ] ++ lib.optionals withPantheon [
    pantheon.granite
  ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  postPatch = ''
    chmod +x postinstall.py # patchShebangs requires executable file
    patchShebangs postinstall.py
    patchShebangs data/set-mime-type-entry.py
  '';

  preFixup = ''
    # Workaround because of https://gitlab.gnome.org/GNOME/file-roller/issues/40
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "file-roller";
      attrPath = "gnome.file-roller";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/FileRoller";
    description = "Archive manager for the GNOME desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members ++ teams.pantheon.members;
  };
}
