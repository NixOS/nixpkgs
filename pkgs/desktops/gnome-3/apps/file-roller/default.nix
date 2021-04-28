{ lib, stdenv, fetchurl, glib, gtk3, meson, ninja, pkg-config, gnome3, gettext, itstool, libxml2, libarchive
, file, json-glib, python3, wrapGAppsHook, fetchpatch, desktop-file-utils, libnotify, nautilus, glibcLocales
, unzip, cpio }:

stdenv.mkDerivation rec {
  pname = "file-roller";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mxwdbfqizakxq65fa8zlvjf48v5f44lv8ckjw8sl8fk2871784l";
  };

  LANG = "en_US.UTF-8"; # postinstall.py

  nativeBuildInputs = [ meson ninja gettext itstool pkg-config libxml2 python3 wrapGAppsHook glibcLocales desktop-file-utils ];

  buildInputs = [ glib gtk3 json-glib libarchive file gnome3.adwaita-icon-theme libnotify nautilus cpio ];

  patches = [
    # Should become obsolete when the following release is out.
    (fetchpatch {
      name = "fix-cpio-path.patch";
      url = "https://gitlab.gnome.org/GNOME/file-roller/-/commit/af27465a3ef07622e89890ef4b1aacbb754b6fb9.patch";
      sha256 = "0r7qlx8yj4qa7jdrgm618bjia7wjryd05fmhcfq2957wh5ww9ffx";
    })
  ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  postPatch = ''
    chmod +x postinstall.py # patchShebangs requires executable file
    patchShebangs postinstall.py
    patchShebangs data/set-mime-type-entry.py
  '';

  # Workaround because of https://gitlab.gnome.org/GNOME/file-roller/-/issues/40
  postFixup = ''
    wrapProgram "$out/bin/file-roller" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "file-roller";
      attrPath = "gnome3.file-roller";
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
