{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nix-update-script
, appstream
, desktop-file-utils
, meson
, ninja
, pkg-config
, polkit
<<<<<<< HEAD
=======
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, vala
, wrapGAppsHook
, editorconfig-core-c
, granite
, gtk3
, gtksourceview4
, gtkspell3
, libgee
, libgit2-glib
, libhandy
, libpeas
, libsoup
, vte
, ctags
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
<<<<<<< HEAD
  version = "7.1.0";
=======
  version = "7.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Dtm0+NqDwfn5HUQEYtHTiyrpM3mHp1wUFOGaxH86YUo=";
  };

=======
    sha256 = "sha256-6ZOdlOCIDy5aWQre15+SrTH/vhY9OeTffY/uTSroELc=";
  };

  patches = [
    # Fix global search action disabled at startup
    # https://github.com/elementary/code/pull/1254
    (fetchpatch {
      url = "https://github.com/elementary/code/commit/1e75388b07c060cc10ecd612076f235b1833fab8.patch";
      sha256 = "sha256-8Djh1orMcmICdYwQFENJCaYlXK0E52NhCmuhlHCz7oM=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    polkit # needed for ITS rules
<<<<<<< HEAD
=======
    python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    editorconfig-core-c
    granite
    gtk3
    gtksourceview4
    gtkspell3
    libgee
    libgit2-glib
    libhandy
    libpeas
    libsoup
    vte
  ];

  # ctags needed in path by outline plugin
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ctags ]}"
    )
  '';

<<<<<<< HEAD
=======
  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Code editor designed for elementary OS";
    homepage = "https://github.com/elementary/code";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.code";
  };
}
