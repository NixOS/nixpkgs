{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, itstool, libcanberra-gtk3, librsvg, libxml2 }:

stdenv.mkDerivation rec {
  name = "four-in-a-row-${version}";
  version = "3.22.2";

  src = fetchurl {
    url = "mirror://gnome/sources/four-in-a-row/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "bc4194e8ab6d1d2a6a63a2e91945cd5465f49ebf0dae2eecacc66e69db56a420";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "four-in-a-row"; attrPath = "gnome3.four-in-a-row"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool libcanberra-gtk3 librsvg
    libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Four-in-a-row;
    description = "Make lines of the same color to win";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
