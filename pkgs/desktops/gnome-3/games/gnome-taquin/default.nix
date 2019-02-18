{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-taquin-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-taquin/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0qijv7wyrjlj56m79la4k7m00712v2m1m994vfx43x3v4isxidgp";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-taquin"; attrPath = "gnome3.gnome-taquin"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg libcanberra-gtk3
    intltool itstool libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Taquin;
    description = "Move tiles so that they reach their places";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
