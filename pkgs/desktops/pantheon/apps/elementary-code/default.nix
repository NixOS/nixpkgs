{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, python3
, desktop-file-utils
, gtk3
, granite
, libgee
, libhandy
, elementary-icon-theme
, appstream
, libpeas
, editorconfig-core-c
, gtksourceview4
, gtkspell3
, libsoup
, vte
, webkitgtk
, ctags
, libgit2-glib
, wrapGAppsHook
, polkit
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = version;
    sha256 = "sha256-AXmMcPj2hf33G5v3TUg+eZwaKOdVlRvoVXglMJFHRjw=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

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
    ctags
    editorconfig-core-c
    elementary-icon-theme
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
    webkitgtk
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

  meta = with lib; {
    description = "Code editor designed for elementary OS";
    homepage = "https://github.com/elementary/code";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.code";
  };
}
