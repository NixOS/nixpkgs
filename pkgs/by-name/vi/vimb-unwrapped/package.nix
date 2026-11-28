{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libsoup_3,
  webkitgtk_6_0,
  gtk4,
  glib-networking,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vimb";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "fanglingsu";
    repo = "vimb";
    tag = finalAttrs.version;
    hash = "sha256-L1MYJb6mdGeCmHD1YNhuKUTWcwOUP301AzdbpuZD09A=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    gtk4
    libsoup_3
    webkitgtk_6_0
    glib-networking
    gsettings-desktop-schemas
  ];

  passthru = {
    inherit gtk4;
    applicationName = "Vimb";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Vim-like browser";
    mainProgram = "vimb";
    longDescription = ''
      A fast and lightweight vim like web browser based on the webkit web
      browser engine and the GTK toolkit. Vimb is modal like the great vim
      editor and also easily configurable during runtime. Vimb is mostly
      keyboard driven and does not detract you from your daily work.
    '';
    homepage = "https://fanglingsu.github.io/vimb/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ evanwporter ];
    platforms = lib.platforms.linux;
  };
})
