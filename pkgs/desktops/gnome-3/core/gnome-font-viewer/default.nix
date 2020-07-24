{ stdenv, meson, ninja, gettext, fetchurl
, pkgconfig, gtk3, glib, libxml2, gnome-desktop, adwaita-icon-theme
, wrapGAppsHook, gnome3, harfbuzz }:

stdenv.mkDerivation rec {
  pname = "gnome-font-viewer";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12xrsqwmvid7hksiw4zhj4jd1qwxn8w0czskbq4yqfprwn1havxa";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkgconfig gettext wrapGAppsHook libxml2 ];
  buildInputs = [ gtk3 glib gnome-desktop adwaita-icon-theme harfbuzz ];

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
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
