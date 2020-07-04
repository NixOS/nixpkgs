{ stdenv
, fetchFromGitHub
, vala
, atk
, cairo
, dconf
, glib
, gtk3
, libwnck3
, libX11
, libXfixes
, libXi
, pango
, gettext
, pkgconfig
, libxml2
, bamf
, gdk-pixbuf
, libdbusmenu-gtk3
, gnome-menus
, libgee
, wrapGAppsHook
, pantheon
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "unstable-2020-02-28";

  outputs = [ "out" "dev" ];

  repoName = "dock";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "ac87d9063dc9c81d90f42f3002ad9c5b49460a82";
    sha256 = "0lhjzd370fza488dav8n155ss486wqv6y7ldkahwg0c3zvlsvha7";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    libxml2 # xmllint
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    bamf
    cairo
    gdk-pixbuf
    glib
    gnome-menus
    dconf
    gtk3
    libX11
    libXfixes
    libXi
    libdbusmenu-gtk3
    libgee
    libwnck3
    pango
  ];

  meta = with stdenv.lib; {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ pantheon.maintainers;
  };
}
