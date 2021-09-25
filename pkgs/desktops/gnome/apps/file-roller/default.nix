{ lib, stdenv, fetchurl, glib, gtk3, meson, ninja, pkg-config, gnome, gettext, itstool, libxml2, libarchive
, file, json-glib, python3, wrapGAppsHook, desktop-file-utils, libnotify, nautilus, glibcLocales
, unzip, cpio }:

stdenv.mkDerivation rec {
  pname = "file-roller";
  version = "3.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "039w1dcpa5ypmv6sm634alk9vbcdkyvy595vkh5gn032jsiqca2a";
  };

  LANG = "en_US.UTF-8"; # postinstall.py

  nativeBuildInputs = [ meson ninja gettext itstool pkg-config libxml2 python3 wrapGAppsHook glibcLocales desktop-file-utils ];

  buildInputs = [ glib gtk3 json-glib libarchive file gnome.adwaita-icon-theme libnotify nautilus cpio ];

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
    maintainers = teams.gnome.members;
  };
}
