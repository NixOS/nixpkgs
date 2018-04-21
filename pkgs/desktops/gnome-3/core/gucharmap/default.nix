{ stdenv, intltool, fetchurl, pkgconfig, gtk3, defaultIconTheme
, glib, desktop-file-utils, bash, appdata-tools
, wrapGAppsHook, gnome3, itstool, libxml2
, callPackage, unzip, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gucharmap-${version}";
  version = "10.0.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gucharmap/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "00gh3lll6wykd2qg1lrj05a4wvscsypmrx7rpb6jsbvb4scnh9mv";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gucharmap"; };
  };

  doCheck = true;

  preConfigure = "patchShebangs gucharmap/gen-guch-unicode-tables.pl";

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook unzip intltool itstool appdata-tools
    gnome3.yelp-tools libxml2 desktop-file-utils gobjectIntrospection
  ];

  buildInputs = [ gtk3 glib gnome3.gsettings-desktop-schemas defaultIconTheme ];

  unicode-data = callPackage ./unicode-data.nix {};

  configureFlags = "--with-unicode-data=${unicode-data}";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gucharmap;
    description = "GNOME Character Map, based on the Unicode Character Database";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
