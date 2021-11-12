{ lib, stdenv
, fetchFromGitHub
, vala
, atk
, cairo
, dconf
, glib
, gtk3
, libwnck
, libX11
, libXfixes
, libXi
, pango
, gettext
, pkg-config
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
, granite
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "unstable-2021-07-16";

  outputs = [ "out" "dev" ];

  repoName = "dock";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "05fd6fccdf1a769f6737a0d7e57e092825348660";
    sha256 = "0lqqq5cx0kk8y7qyjx7z2k3v1kw2xxzns968ianarcji19wzcns4";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    libxml2 # xmllint
    pkg-config
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
    granite
    gtk3
    libX11
    libXfixes
    libXi
    libdbusmenu-gtk3
    libgee
    libwnck
    pango
  ];

  meta = with lib; {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ teams.pantheon.members;
    mainProgram = "plank";
  };
}
