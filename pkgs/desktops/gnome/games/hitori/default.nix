{ stdenv
, lib
, fetchurl
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hitori";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/hitori/${lib.versions.major finalAttrs.version}/hitori-${finalAttrs.version}.tar.xz";
    sha256 = "QicL1PlSXRgNMVG9ckUzXcXPJIqYTgL2j/kw2nmeWDs=";
  };

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
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "hitori";
      attrPath = "gnome.hitori";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Hitori";
    description = "GTK application to generate and let you play games of Hitori";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
})
