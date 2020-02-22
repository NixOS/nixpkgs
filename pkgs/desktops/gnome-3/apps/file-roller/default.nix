{ stdenv, fetchurl, glib, gtk3, meson, ninja, pkgconfig, gnome3, gettext, itstool, libxml2, libarchive
, file, json-glib, python3, wrapGAppsHook, desktop-file-utils, libnotify, nautilus, glibcLocales }:

stdenv.mkDerivation rec {
  pname = "file-roller";
  version = "3.32.4";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "05s046br4fcli1d3wngh4jmwi0aikpfkl1px1cahskj4rfzjqfqv";
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
