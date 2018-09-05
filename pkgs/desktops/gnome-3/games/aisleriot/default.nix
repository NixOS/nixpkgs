{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, gtk3
, wrapGAppsHook, librsvg, libxml2, desktop-file-utils
, guile_2_0, libcanberra-gtk3 }:

stdenv.mkDerivation rec {
  name = "aisleriot-${version}";
  version = "3.22.6";

  src = fetchurl {
    url = "mirror://gnome/sources/aisleriot/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "182sgqb3rk70v5h571ndln883q14s661pdxg3l48rxxvfmqp16i3";
  };

  configureFlags = [
    "--with-card-theme-formats=svg"
    "--with-platform=gtk-only" # until they remove GConf
  ];

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook libxml2 desktop-file-utils ];
  buildInputs = [ gtk3 librsvg guile_2_0 libcanberra-gtk3 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "aisleriot";
      attrPath = "gnome3.aisleriot";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Aisleriot;
    description = "A collection of patience games written in guile scheme";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
