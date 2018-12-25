{ stdenv, intltool, fetchFromGitLab, fetchpatch, pkgconfig, gtk3, defaultIconTheme
, glib, desktop-file-utils, gtk-doc, autoconf, automake, libtool
, wrapGAppsHook, gnome3, itstool, libxml2, yelp-tools
, docbook_xsl, docbook_xml_dtd_412, gsettings-desktop-schemas
, callPackage, unzip, gobject-introspection }:

let
  unicode-data = callPackage ./unicode-data.nix {};
in stdenv.mkDerivation rec {
  name = "gucharmap-${version}";
  version = "11.0.3";

  outputs = [ "out" "lib" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gucharmap";
    rev = version;
    sha256 = "1a590nxy8jdf6zxh6jdsyvhxyaz94ixx3aa1pj7gicf1aqp26vnh";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook unzip intltool itstool
    autoconf automake libtool gtk-doc docbook_xsl docbook_xml_dtd_412
    yelp-tools libxml2 desktop-file-utils gobject-introspection
  ];

  buildInputs = [ gtk3 glib gsettings-desktop-schemas defaultIconTheme ];

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
      packageName = "gucharmap";
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
