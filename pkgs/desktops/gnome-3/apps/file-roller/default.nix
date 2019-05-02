{ stdenv, fetchurl, glib, gtk3, meson, ninja, pkgconfig, gnome3, gettext, itstool, libxml2, libarchive
, file, json-glib, python3, wrapGAppsHook, desktop-file-utils, libnotify, nautilus, glibcLocales }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0irm72cf8222h93skivn0nn0ckahiiiimy4rb9r3ccjvhi3hiaqw";
  };

  LANG = "en_US.UTF-8"; # postinstall.py

  nativeBuildInputs = [ meson ninja gettext itstool pkgconfig libxml2 python3 wrapGAppsHook glibcLocales desktop-file-utils ];

  buildInputs = [ glib gtk3 json-glib libarchive file gnome3.adwaita-icon-theme libnotify nautilus ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  postPatch = ''
    chmod +x postinstall.py # patchShebangs requires executable file
    patchShebangs postinstall.py
    patchShebangs data/set-mime-type-entry.py
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
