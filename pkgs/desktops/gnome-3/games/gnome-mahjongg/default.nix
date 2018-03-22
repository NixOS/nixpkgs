{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-mahjongg-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "f5972a14fa4ad04153bd6e68475b85cd79c6b44f6cac1fe1edb64dbad4135218";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-mahjongg"; attrPath = "gnome3.gnome-mahjongg"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mahjongg;
    description = "Disassemble a pile of tiles by removing matching pairs";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
