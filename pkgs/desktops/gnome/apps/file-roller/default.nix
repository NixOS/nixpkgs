{ lib
, stdenv
, fetchurl
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
, libhandy
, json-glib
, libarchive
, libnotify
, nautilus
, unzip
}:

stdenv.mkDerivation rec {
  pname = "file-roller";
  version = "3.42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HEOObVPsEP9PLrWyLXu/KKfCqElXq2SnUcHN88UjAsc=";
  };

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
    libhandy
    json-glib
    libarchive
    libnotify
    nautilus
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
