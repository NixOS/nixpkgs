{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, udev
, glib
, gnome
, vala
, gobject-introspection
, fetchpatch
, glibcLocales
, umockdev
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgudev";
  version = "238";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgudev/${lib.versions.majorMinor finalAttrs.version}/libgudev-${finalAttrs.version}.tar.xz";
    hash = "sha256-YSZqsa/J1z28YKiyr3PpnS/f9H2ZVE0IV2Dk+mZ7XdE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    glib # for glib-mkenums needed during the build
    gobject-introspection
  ];

  buildInputs = [
    udev
    glib
  ];

  checkInputs = [
    glibcLocales
    umockdev
  ];

  doCheck = true;
  mesonFlags = lib.optional (!finalAttrs.finalPackage.doCheck) "-Dtests=disabled";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libgudev";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A library that provides GObject bindings for libudev";
    homepage = "https://wiki.gnome.org/Projects/libgudev";
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
})
