{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, libxml2, intltool, itstool }:

stdenv.mkDerivation rec {
  name = "gnome-tetravex-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tetravex/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0a6d7ff5ffcd6c05454a919d46a2e389d6b5f87bc80e82c52c2f20d9d914e18d";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-tetravex"; attrPath = "gnome3.gnome-tetravex"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tetravex;
    description = "Complete the puzzle by matching numbered tiles";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
