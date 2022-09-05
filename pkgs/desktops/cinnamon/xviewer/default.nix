{ stdenv
, lib
, fetchFromGitHub
, cinnamon-desktop
, docbook_xsl
, exempi
, gdk-pixbuf
, glib
, gobject-introspection
, gtk3
, gtk-doc
, itstool
, lcms2
, libexif
, libjpeg
, libpeas
, librsvg
, libxml2
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, xapp
, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "xviewer";
  version = "3.2.10";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-c3K9yjeaAlyXqgxzHgnLXgqwaB5Fdw+mS9jricy8QA8=";
  };

  nativeBuildInputs = [
    cinnamon-desktop
    docbook_xsl
    gdk-pixbuf
    gobject-introspection
    gtk-doc
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
    yelp-tools
  ];

  buildInputs = [
    exempi
    glib
    gtk3
    lcms2
    libexif
    libjpeg
    libpeas
    librsvg
    libxml2
    xapp
  ];

  meta = with lib; {
    description = "A generic image viewer from Linux Mint";
    homepage = "https://github.com/linuxmint/xviewer";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tu-maurice ] ++ teams.cinnamon.members;
  };
}
