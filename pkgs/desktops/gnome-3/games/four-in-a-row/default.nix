{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, gettext, itstool, libcanberra-gtk3, librsvg, libxml2 }:

stdenv.mkDerivation rec {
  name = "four-in-a-row-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/four-in-a-row/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1iszaay2r92swb0q67lmip6r1w3hw2dwmlgnz9v2h6blgdyncs4k";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook gettext itstool libxml2 ];
  buildInputs = [ gtk3 libcanberra-gtk3 librsvg gnome3.defaultIconTheme ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "four-in-a-row";
      attrPath = "gnome3.four-in-a-row";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Four-in-a-row;
    description = "Make lines of the same color to win";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
