{ stdenv, intltool, fetchurl, pkgconfig, gtk3
, glib, desktop-file-utils, bash, appdata-tools
, wrapGAppsHook, gnome3, itstool, libxml2
, callPackage, unzip, gobjectIntrospection }:

# TODO: icons and theme still does not work
# use packaged gnome3.adwaita-icon-theme

stdenv.mkDerivation rec {
  name = "gucharmap-${version}";
  version = "10.0.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gucharmap/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "ac07d75924e2d8f436d9492e8f7d54cf109404d34de06886a3967563cd1726a4";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gucharmap"; };
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  preConfigure = "patchShebangs gucharmap/gen-guch-unicode-tables.pl";

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook unzip intltool itstool appdata-tools
    gnome3.yelp-tools libxml2 desktop-file-utils gobjectIntrospection
  ];

  buildInputs = [ gtk3 glib gnome3.gsettings-desktop-schemas ];

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
