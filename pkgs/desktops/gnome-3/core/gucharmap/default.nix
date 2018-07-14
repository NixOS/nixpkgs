{ stdenv, intltool, fetchFromGitLab, pkgconfig, gtk3, defaultIconTheme
, glib, desktop-file-utils, bash, appdata-tools, gtk-doc, autoconf, automake, libtool
, wrapGAppsHook, gnome3, itstool, libxml2
, callPackage, unzip, gobjectIntrospection }:

let
  unicode-data = callPackage ./unicode-data.nix {};
in stdenv.mkDerivation rec {
  name = "gucharmap-${version}";
  version = "11.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gucharmap";
    rev = version;
    sha256 = "13iw4fa6mv8vi8bkwk0bbhamnzbaih0c93p4rh07khq6mxa6hnpi";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook unzip intltool itstool appdata-tools
    autoconf automake libtool gtk-doc
    gnome3.yelp-tools libxml2 desktop-file-utils gobjectIntrospection
  ];

  buildInputs = [ gtk3 glib gnome3.gsettings-desktop-schemas defaultIconTheme ];

  configureFlags = [
    "--with-unicode-data=${unicode-data}"
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
