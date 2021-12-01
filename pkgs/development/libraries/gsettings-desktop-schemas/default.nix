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
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "dyiZcuWW0ERYPwwFYwbY8dvYrc+RKRClDaCmY+ZTMu0=";
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

  mesonFlags = [
    "-Dintrospection=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
  ];

  postPatch = ''
    chmod +x build-aux/meson/post-install.py
    patchShebangs build-aux/meson/post-install.py
  '';

  # meson installs the schemas to share/glib-2.0/schemas
  # We add the override file there too so it will be compiled and later moved by
  # glib's setup hook.
  preInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
    cat - > $out/share/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      [org.gnome.desktop.background]
      picture-uri='''

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
