{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gsound, gettext, itstool, libxml2, libgnome-games-support
, libgee, meson, ninja, python3, desktop-file-utils, adwaita-icon-theme }:

stdenv.mkDerivation rec {
  pname = "gnome-robots";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1qpzpsyj9i5dsfy7anfb2dcm602bjkcgqj86fxvnxy6llx56ks0z";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-robots"; attrPath = "gnome3.gnome-robots"; };
  };

  nativeBuildInputs = [
    pkgconfig meson ninja python3
    libxml2 wrapGAppsHook gettext itstool desktop-file-utils
  ];
  buildInputs = [
    gtk3 librsvg gsound libgnome-games-support libgee adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Robots";
    description = "Avoid the robots and make them crash into each other";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
