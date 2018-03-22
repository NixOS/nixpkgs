{ fetchurl, stdenv, gettext, pkgconfig, itstool, libxml2, libjpeg, gnome3
, shared-mime-info, wrapGAppsHook, librsvg, libexif, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "eog-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/eog/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "b53e3d4dfa7d0085b829a5fb95f148a099803c00ef276be7685efd5ec38807ad";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "eog"; attrPath = "gnome3.eog"; };
  };

  nativeBuildInputs = [ pkgconfig gettext itstool wrapGAppsHook gobjectIntrospection ];

  buildInputs = with gnome3;
    [ libxml2 libjpeg gtk glib libpeas librsvg
      gsettings-desktop-schemas shared-mime-info adwaita-icon-theme
      gnome-desktop libexif dconf ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/EyeOfGnome;
    platforms = platforms.linux;
    description = "GNOME image viewer";
    maintainers = gnome3.maintainers;
  };
}
