{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf
, librsvg, intltool, itstool, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "tali-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "5ba17794d6fb06b794daaffa62a6aaa372b7de8886ce5ec596c37e62bb71728b";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "tali"; attrPath = "gnome3.tali"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  libxml2 itstool intltool wrapGAppsHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tali;
    description = "Sort of poker with dice and less money";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
