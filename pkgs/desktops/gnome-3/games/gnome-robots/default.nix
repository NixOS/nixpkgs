{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, gettext, itstool, libxml2, libgnome-games-support
, libgee, meson, ninja, python3, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-robots-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1xp1sijl5k7wmnbb0hdgh4ajxgp74k7fcnmd5c6rw6lf51wpinyh";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-robots"; attrPath = "gnome3.gnome-robots"; };
  };

  nativeBuildInputs = [
    pkgconfig meson ninja python3
    libxml2 gnome3.adwaita-icon-theme
    wrapGAppsHook gettext itstool desktop-file-utils
  ];
  buildInputs = [
    gtk3 librsvg libcanberra-gtk3 libgnome-games-support libgee
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Robots;
    description = "Avoid the robots and make them crash into each other";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
