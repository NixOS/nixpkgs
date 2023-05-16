{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, python3
, vala
, gtk3
, libxml2
, libhandy
<<<<<<< HEAD
, libportal-gtk3
, webkitgtk_4_1
, elementary-gtk-theme
, elementary-icon-theme
=======
, webkitgtk_4_1
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, folks
, glib-networking
, granite
, evolution-data-server
, wrapGAppsHook
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-mail";
<<<<<<< HEAD
  version = "7.2.0";
=======
  version = "7.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "mail";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-hBOogZ9ZNS9KnuNn+jNhTtlupBxZL2DG/CiuBR1kFu0=";
=======
    sha256 = "sha256-dvDlvn8KvFmiP/NClRtHNEs5gPTUjlzgTYmgIaCfoLw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
    elementary-icon-theme
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    evolution-data-server
    folks
    glib-networking
    granite
    gtk3
    libgee
    libhandy
<<<<<<< HEAD
    libportal-gtk3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    webkitgtk_4_1
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
    description = "Mail app designed for elementary OS";
    homepage = "https://github.com/elementary/mail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ethancedwards8 ] ++ teams.pantheon.members;
    mainProgram = "io.elementary.mail";
  };
}
