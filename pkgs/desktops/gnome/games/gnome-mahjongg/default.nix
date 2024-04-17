{ stdenv
, lib
, fetchurl
, pkg-config
, gnome
, gtk4
, wrapGAppsHook4
, libadwaita
, librsvg
, gettext
, itstool
, libxml2
, meson
, ninja
, glib
, vala
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-mahjongg";
  version = "3.40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-jtVO7K3jawgzaQb9jmyQKg1ve7u7Z2U8I5Vqa2MSI/Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    desktop-file-utils
    pkg-config
    libxml2
    itstool
    gettext
    wrapGAppsHook4
    glib # for glib-compile-schemas
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Mahjongg";
    description = "Disassemble a pile of tiles by removing matching pairs";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
