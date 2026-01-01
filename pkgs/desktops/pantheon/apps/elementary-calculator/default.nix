{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  elementary-gtk-theme,
  elementary-icon-theme,
  granite7,
  gtk4,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "elementary-calculator";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calculator";
    rev = version;
    sha256 = "sha256-XBOe3v6lKoICgEh78JoVH0Ojs8tr5PxKHQGk63MX6pQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    elementary-icon-theme
    granite7
    gtk4
    libgee
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/elementary/calculator";
    description = "Calculator app designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    homepage = "https://github.com/elementary/calculator";
    description = "Calculator app designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "io.elementary.calculator";
  };
}
