{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, cinnamon-desktop
, file
, gdk-pixbuf
, glib
, gobject-introspection
, gtk-doc
, gtk3
, intltool
, itstool
, lcms2
, libexif
, libjpeg
, libpeas
, libtool
, libxml2
, pkg-config
, shared-mime-info
, wrapGAppsHook
, xapps
, yelp-tools }:

stdenv.mkDerivation rec {
  pname = "xviewer";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-hvoTb9afyVdcm5suB1ZxkxUyNFSVRFjYuNVc0jE3RF0=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    autoreconfHook
    cinnamon-desktop
    gdk-pixbuf
    gobject-introspection
    gtk-doc
    intltool
    itstool
    libtool
    pkg-config
    yelp-tools
  ];

  buildInputs = [
    glib
    gtk3
    libexif
    libjpeg
    libpeas
    libxml2
    shared-mime-info
    xapps
    lcms2
  ];

  meta = with lib; {
    description = "A generic image viewer from Linux Mint";
    homepage = "https://github.com/linuxmint/xviewer";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tu-maurice ];
  };
}
