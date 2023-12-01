{ lib
, stdenv
, fetchurl
, fetchpatch
, desktop-file-utils
, meson
, ninja
, vala
, libxslt
, pkg-config
, glib
, gtk3
, libhandy
, gnome
, dconf
, libxml2
, gettext
, docbook-xsl-nons
, wrapGAppsHook
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "dconf-editor";
  version = "45.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-EYApdnju2uYhfMUUomOMGH0vHR7ycgy5B5t0DEKZQd0=";
  };

  patches = [
    # Fix crash with GSETTINGS_SCHEMA_DIR env var.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/dconf-editor/-/commit/baf183737d459dcde065c9f8f6fe5be7ed874de6.patch";
      hash = "sha256-Vp0qjJChDr6IarUD+tZPLJhdI8v8r6EzWNfqFSnGvqQ=";
    })

    # Look for compiled schemas in NIX_GSETTINGS_OVERRIDES_DIR
    # environment variable, to match what we patched GLib to do.
    ./schema-override-variable.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
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
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    dconf
  ];

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
    platforms = platforms.unix;
  };
}
