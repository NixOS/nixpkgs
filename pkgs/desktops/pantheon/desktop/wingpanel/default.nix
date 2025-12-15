{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  wayland-scanner,
  wrapGAppsHook3,
  pkg-config,
  meson,
  ninja,
  vala,
  gala,
  glib,
  gtk3,
  libgee,
  granite,
  gettext,
  mutter,
  wayland,
  json-glib,
  elementary-gtk-theme,
  elementary-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel";
  version = "8.0.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel";
    tag = version;
    hash = "sha256-+m1TydQtbXuA7uS6hZVC8z6JgOUxDh/QXL/4tROHhwk=";
  };

  patches = [
    ./indicators.patch
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    elementary-icon-theme
    gala
    granite
    json-glib
    libgee
    mutter
    wayland
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # this GTK theme is required
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"

      # the icon theme is required
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extensible top panel for Pantheon";
    longDescription = ''
      Wingpanel is an empty container that accepts indicators as extensions,
      including the applications menu.
    '';
    homepage = "https://github.com/elementary/wingpanel";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.wingpanel";
  };
}
