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
, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "xviewer";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-OyHSBXtJ/TExl06NLUAaIZq4u0+fI3YGQ37HRZeNP+0=";
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
    maintainers = with maintainers; [ tu-maurice ] ++ teams.cinnamon.members;
  };
}
