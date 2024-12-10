{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  meson,
  ninja,
  # just for passthru
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gsettings-desktop-schemas";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-STpGoRYbY4jVeqcvYyp5zpbELV/70dCwD0luxYdvhXU=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs =
    [
      glib
      meson
      ninja
      pkg-config
    ]
    ++ lib.optionals withIntrospection [
      gobject-introspection
    ];

  mesonFlags = [
    (lib.mesonBool "introspection" withIntrospection)
  ];

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
    homepage = "https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas";
    description = "Collection of GSettings schemas for settings shared by various components of a desktop";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
  };
}
