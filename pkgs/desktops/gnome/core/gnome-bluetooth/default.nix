{ lib
, stdenv
, fetchurl
, gnome
, meson
, ninja
, pkg-config
, gtk3
, gettext
, glib
, udev
, itstool
, libxml2
, wrapGAppsHook
, libnotify
, libcanberra-gtk3
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-bluetooth";
  version = "3.34.5";

  # TODO: split out "lib"
  outputs = [ "out" "dev" "devdoc" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1a9ynlwwkb3wpg293ym517vmrkk63y809mmcv9a21k5yr199x53c";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    libxml2
    wrapGAppsHook
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    python3
  ];

  buildInputs = [
    glib
    gtk3
    udev
    libnotify
    libcanberra-gtk3
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dicon_update=false"
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://help.gnome.org/users/gnome-bluetooth/stable/index.html.en";
    description = "Application that lets you manage Bluetooth in the GNOME desktop";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
