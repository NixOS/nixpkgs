{ lib, stdenv
, fetchurl
, pkg-config
, glib
, gobject-introspection
, meson
, ninja
, python3
  # just for passthru
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gsettings-desktop-schemas";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "ZoYzWp7WI/euInb++lCkENTnHUIxiAgkcUBwyzFzI9I=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    python3
    gobject-introspection
  ];

  postPatch = ''
    chmod +x build-aux/meson/post-install.py
    patchShebangs build-aux/meson/post-install.py
  '';

  preInstall = ''
    # Meson installs the schemas to share/glib-2.0/schemas
    # We add the override file there too so it will be compiled and later moved by
    # glib's setup hook.
    mkdir -p $out/share/glib-2.0/schemas
    cat - > $out/share/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      # These paths are supposed to refer to gnome-backgrounds
      # but since we do not use FHS, they are broken.
      # And we do not want to hardcode the correct paths
      # since then every GTK app would pull in gnome-backgrounds.
      # Let’s just override the broken paths so that people are not confused.
      [org.gnome.desktop.background]
      picture-uri='''
      picture-uri-dark='''

      [org.gnome.desktop.screensaver]
      picture-uri='''
    EOF
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Collection of GSettings schemas for settings shared by various components of a desktop";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
  };
}
