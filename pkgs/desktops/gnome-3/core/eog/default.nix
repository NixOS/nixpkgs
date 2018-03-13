{ fetchurl, stdenv, gettext, pkgconfig, itstool, libxml2, libjpeg, gnome3
, shared-mime-info, wrapGAppsHook, librsvg, libexif, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "eog-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/eog/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0d8fi5ydsh8n7d85dps8svl1bhid1p8jbnlwiqywj2gd2wpxpyjv";
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
