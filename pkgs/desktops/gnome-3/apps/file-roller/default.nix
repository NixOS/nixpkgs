{ stdenv, fetchurl, glib, gtk, meson, ninja, pkgconfig, gnome3, gettext, itstool, libxml2, libarchive
, file, json-glib, wrapGAppsHook, desktop-file-utils, libnotify, nautilus, glibcLocales }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "09y2blmlsccfxc2npcayhicq00r9n03897s1aizkahn1m970hjsp";
  };

  LANG = "en_US.UTF-8"; # postinstall.py

  nativeBuildInputs = [ meson ninja gettext itstool pkgconfig libxml2 wrapGAppsHook glibcLocales desktop-file-utils ];

  buildInputs = [ glib gtk json-glib libarchive file gnome3.defaultIconTheme libnotify nautilus ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  postPatch = ''
    chmod +x postinstall.py # patchShebangs requires executable file
    patchShebangs postinstall.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "file-roller";
      attrPath = "gnome3.file-roller";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/FileRoller;
    description = "Archive manager for the GNOME desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
