{ stdenv, intltool, fetchFromGitLab, fetchpatch, pkgconfig, gtk3, adwaita-icon-theme
, glib, desktop-file-utils, gtk-doc, autoconf, automake, libtool
, wrapGAppsHook, gnome3, itstool, libxml2, yelp-tools
, docbook_xsl, docbook_xml_dtd_412, gsettings-desktop-schemas
, callPackage, unzip, gobject-introspection }:

let
  unicode-data = callPackage ./unicode-data.nix {};
in stdenv.mkDerivation rec {
  pname = "gucharmap";
  version = "12.0.1";

  outputs = [ "out" "lib" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "0si3ymyfzc5v7ly0dmcs3qgw2wp8cyasycq5hmcr8frl09lr6gkw";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook unzip intltool itstool
    autoconf automake libtool gtk-doc docbook_xsl docbook_xml_dtd_412
    yelp-tools libxml2 desktop-file-utils gobject-introspection
  ];

  buildInputs = [ gtk3 glib gsettings-desktop-schemas adwaita-icon-theme ];

  configureFlags = [
    "--with-unicode-data=${unicode-data}"
    "--enable-gtk-doc"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs gucharmap/gen-guch-unicode-tables.pl
  '';

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME Character Map, based on the Unicode Character Database";
    homepage = https://wiki.gnome.org/Apps/Gucharmap;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
