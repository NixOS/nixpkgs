{ lib
, stdenv
, fetchurl
, meson
, ninja
, vala
, libxslt
, pkg-config
, glib
, gtk3
, gnome
, python3
, dconf
, libxml2
, gettext
, docbook-xsl-nons
, wrapGAppsHook
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "dconf-editor";
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Vxr0x9rU8Em1PmzXKLea3fCMJ92ra8V7OW0hGGbueeM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    libxslt
    pkg-config
    wrapGAppsHook
    gettext
    docbook-xsl-nons
    libxml2
    gobject-introspection
    python3
  ];

  buildInputs = [
    glib
    gtk3
    dconf
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "GSettings editor for GNOME";
    homepage = "https://wiki.gnome.org/Apps/DconfEditor";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
