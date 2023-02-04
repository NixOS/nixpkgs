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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = version;
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
