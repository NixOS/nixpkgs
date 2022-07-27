{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, vala
, libxslt
, pkg-config
, glib
, gtk3
, libhandy
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
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-SNYG/ZZ20xX3ysml7kh/U8mDveX4jb09Qpd8qL6F+/s=";
  };

  patches = [
    # Look for compiled schemas in NIX_GSETTINGS_OVERRIDES_DIR
    # environment variable, to match what we patched GLib to do.
    ./schema-override-variable.patch
  ];

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
    libhandy
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
