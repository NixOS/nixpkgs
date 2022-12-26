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
, libtool
, libxml2
, pkg-config
, shared-mime-info
, wrapGAppsHook
, xapp
, yelp-tools
, libsecret
, webkitgtk
, libwebp
, librsvg
, json-glib
, gnome
, clutter
}:

stdenv.mkDerivation rec {
  pname = "pix";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-7g0j1cWgNtWlqKWzBnngUA2WNr8Zh8YO/jJ8OdTII7Y=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    autoreconfHook
    cinnamon-desktop
    gdk-pixbuf
    gnome.gnome-common
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
    xapp
    libsecret
    webkitgtk
    libwebp
    librsvg
    json-glib
    clutter
  ];

  meta = with lib; {
    description = "A generic image viewer from Linux Mint";
    homepage = "https://github.com/linuxmint/pix";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
