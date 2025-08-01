{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
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
  libpeas2,
  libsoup_3,
  vte,
  ctags,
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = version;
    hash = "sha256-muW7K9cFITZaoNi3id+iplmokN5sSE8x1CVQ62+myUU=";
  };

  patches = [
    # Fix build with GCC 14
    # https://github.com/elementary/code/pull/1606
    (fetchpatch {
      url = "https://github.com/elementary/code/commit/9b8347adcbb94f3186815413d927eecc51be2ccf.patch";
      hash = "sha256-VhpvWgOGniOEjxBOjvX30DZIRGalxfPlb9j1VaOAJTA=";
    })
  ];

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
