{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  polkit,
  vala,
  wrapGAppsHook3,
  editorconfig-core-c,
  granite,
  gsettings-desktop-schemas,
  gtk3,
  gtksourceview4,
  gtkspell3,
  libgee,
  libgit2-glib,
  libhandy,
  libpeas2,
  libsoup_3,
  vte,
  ctags,
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    tag = version;
    hash = "sha256-DZ6smq339VgR33jQm0OFD9CM8sQ0Rz7aHKL1EWFSyBM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    polkit # needed for ITS rules
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    editorconfig-core-c
    granite
    gsettings-desktop-schemas
    gtk3
    gtksourceview4
    gtkspell3
    libgee
    libgit2-glib
    libhandy
    libpeas2
    libsoup_3
    vala # for ValaSymbolResolver provided by libvala
    vte
  ];

  # ctags needed in path by outline plugin
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ctags ]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Code editor designed for elementary OS";
    homepage = "https://github.com/elementary/code";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.code";
  };
}
