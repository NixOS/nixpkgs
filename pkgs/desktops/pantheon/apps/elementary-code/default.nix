{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, appstream
, desktop-file-utils
, meson
, ninja
, pkg-config
, polkit
, python3
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
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = version;
    sha256 = "sha256-QhJNRhYgGbPMd7B1X3kG+pnC/lGUoF7gc7O1PdG49LI=";
  };

  patches = [
    # Fix drag and drop of accented text and between tabs
    # https://github.com/elementary/code/pull/1194
    (fetchpatch {
      url = "https://github.com/elementary/code/commit/1ed7b590768ea9cb5b4658e27d9dc7ac224442ae.patch";
      sha256 = "sha256-VrYcEbkzQKi5gFB/Vw/0NITZvSXKXfuEv2R3m0VALVM=";
    })
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    polkit # needed for ITS rules
    python3
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

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

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
