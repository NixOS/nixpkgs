{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gnome
, glib
, gtk3
, cairo
, wrapGAppsHook
, libxml2
, python3
, gettext
, itstool
, desktop-file-utils
, adwaita-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "hitori";
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/hitori/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "99cQPLBjP7ATcwExqYw646IWK5+5SZ/H8ZUS1YG/ZWk=";
  };

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:3:0: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/hitori/-/commit/d25728e122f1d7b985029a5ba96810c3e57c27f7.patch";
      sha256 = "LwBpFFr+vLacLTpto7PwvO1p2lku6epyEv9YZvUvW+g=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    desktop-file-utils
    libxml2
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    cairo
    adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Hitori";
    description = "GTK application to generate and let you play games of Hitori";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
