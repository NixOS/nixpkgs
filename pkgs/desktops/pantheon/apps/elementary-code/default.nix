{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  appstream,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  polkit,
  vala,
  wrapGAppsHook3,
  editorconfig-core-c,
  granite,
  gtk3,
  gtksourceview4,
  gtkspell3,
  libgee,
  libgit2-glib,
  libhandy,
  libpeas,
  libsoup,
  vte,
  ctags,
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = version;
    sha256 = "sha256-6lvn8c+JfbtZQf5dtViosVqtt/RWL6B/MvksXqmCfFs=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
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
