{ lib
, stdenv
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
, meson
, ninja
, granite
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "unstable-2021-12-08";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = "5e4b5ba2eec3b522e107ad834a59c0f1271d4699";
    sha256 = "sha256-/Ul21t9VFxhmlQbfx4eY86UKU33hiRfXF9OPHBzPe5o=";
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

  postInstall = ''
    # elementary/dock/master is missing a Meson post
    # install script that does this. This has been
    # resolved after the dock rewrite (the `main` branch).
    # https://github.com/elementary/default-settings/issues/267
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ teams.pantheon.members;
    mainProgram = "plank";
  };
}
