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

  patches = [
    # Conditionally disable one test that requires a locale implementation
    # https://gitlab.gnome.org/GNOME/libgudev/-/merge_requests/31
    ./tests-skip-double-test-on-stub-locale-impls.patch
  ];

  postPatch = ''
    # The relative location of LD_PRELOAD works for Glibc but not for other loaders (e.g. pkgsMusl)
    substituteInPlace tests/meson.build \
      --replace "LD_PRELOAD=libumockdev-preload.so.0" "LD_PRELOAD=${lib.getLib umockdev}/lib/libumockdev-preload.so.0"
  '';

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
