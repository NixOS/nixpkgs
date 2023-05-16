<<<<<<< HEAD
{ stdenv
, lib
=======
{ lib, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, glibcLocales
, umockdev
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgudev";
  version = "238";
=======
}:

stdenv.mkDerivation rec {
  pname = "libgudev";
  version = "237";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchurl {
<<<<<<< HEAD
    url = "mirror://gnome/sources/libgudev/${lib.versions.majorMinor finalAttrs.version}/libgudev-${finalAttrs.version}.tar.xz";
    hash = "sha256-YSZqsa/J1z28YKiyr3PpnS/f9H2ZVE0IV2Dk+mZ7XdE=";
  };

  strictDeps = true;

=======
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1al6nr492nzbm8ql02xhzwci2kwb1advnkaky3j9636jf08v41hd";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/libgudev/-/merge_requests/27
    (fetchpatch {
      name = "gir-dep";
      url = "https://gitlab.gnome.org/GNOME/libgudev/-/commit/6bdde16a0cfde462502fce1d9a7eb6ec33f388bb.diff";
      sha256 = "sha256-bDtLUxOLEgyJURshqEQC4YCBTUVzQQP4qoWL786b3Z8=";
    })
    (fetchpatch {
      name = "vapi-dep";
      url = "https://gitlab.gnome.org/GNOME/libgudev/-/commit/d1f6457910842ba869c9871e7a2131fbe0d6b6be.diff";
      sha256 = "sha256-/PY8ziZST/vQvksJm69a3O6/YesknIxCDvj0z40piik=";
    })
    (fetchpatch {
      name = "gtk-doc-dep";
      url = "https://gitlab.gnome.org/GNOME/libgudev/-/commit/34336cbadbcaac8b9b029f730eed0bdf4c633617.diff";
      sha256 = "sha256-Bk05xe69LGqWH1uhLMZhwbVMSsCTyBrrOvqWic2TTd4=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  checkInputs = [
    glibcLocales
    umockdev
  ];

  doCheck = true;
  mesonFlags = lib.optional (!finalAttrs.finalPackage.doCheck) "-Dtests=disabled";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libgudev";
=======
  mesonFlags = [
    # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway
    "-Dtests=disabled"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
