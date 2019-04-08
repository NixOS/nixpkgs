{ stdenv, meson, ninja, gettext, fetchurl
, pkgconfig, gtk3, glib, libxml2, gnome-desktop, adwaita-icon-theme
, wrapGAppsHook, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-font-viewer-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1wwnx2zrlbd2d6np7m9s78alx6j6ranrnh1g2z6zrv9qcj8rpzz5";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkgconfig gettext wrapGAppsHook libxml2 ];
  buildInputs = [ gtk3 glib gnome-desktop adwaita-icon-theme ];

  # Do not run meson-postinstall.sh
  preConfigure = "sed -i '2,$ d'  meson-postinstall.sh";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-font-viewer";
      attrPath = "gnome3.gnome-font-viewer";
    };
  };

  meta = with stdenv.lib; {
    description = "Program that can preview fonts and create thumbnails for fonts";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
