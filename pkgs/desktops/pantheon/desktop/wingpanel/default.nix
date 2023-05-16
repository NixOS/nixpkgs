{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, wrapGAppsHook
, pkg-config
, meson
, ninja
, vala
, gala
, gtk3
, libgee
, granite
, gettext
, mutter
, mesa
, json-glib
<<<<<<< HEAD
=======
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, elementary-gtk-theme
, elementary-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "wingpanel";
<<<<<<< HEAD
  version = "3.0.5";
=======
  version = "3.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-xowGdaH0e6y0Q2xSl0kUa01rxxoEQ0qXB3sUol0YDBA=";
=======
    sha256 = "sha256-dShC6SXjOJmiLI6TUEZsthv5scnm9Jzum+sG/NkWAyM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./indicators.patch
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
<<<<<<< HEAD
=======
    python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    gala
    granite
    gtk3
    json-glib
    libgee
    mutter
    mesa # for libEGL
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    description = "The extensible top panel for Pantheon";
    longDescription = ''
      Wingpanel is an empty container that accepts indicators as extensions,
      including the applications menu.
    '';
    homepage = "https://github.com/elementary/wingpanel";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.wingpanel";
  };
}
