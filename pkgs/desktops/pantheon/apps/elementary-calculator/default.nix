{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook4
<<<<<<< HEAD
, elementary-gtk-theme
, elementary-icon-theme
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, granite7
, gtk4
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-calculator";
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calculator";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-PLdPu43ns03vhBwaGw4BWCLNvcJbhUA+5Gr5b//TqfA=";
=======
    sha256 = "sha256-7aKJDlpODIysrHtqtD5wfd+dULFpD+LfWsjzg3OAxkY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
<<<<<<< HEAD
    elementary-icon-theme
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    granite7
    gtk4
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

<<<<<<< HEAD
  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/calculator";
    description = "Calculator app designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.calculator";
  };
}
