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
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel";
    rev = version;
    sha256 = "sha256-3UNtqfDqgclRE8Pe9N8rOt6i2FG6lKNfJAv5Q2OYXUU=";
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

  meta = with lib; {
    description = "Extensible top panel for Pantheon";
    longDescription = ''
      Wingpanel is an empty container that accepts indicators as extensions,
      including the applications menu.
    '';
    homepage = "https://github.com/elementary/wingpanel";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.wingpanel";
  };
}
