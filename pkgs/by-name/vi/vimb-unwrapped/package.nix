{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libsoup_3,
  webkitgtk_4_1,
  gtk3,
  glib-networking,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "vimb";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "fanglingsu";
    repo = "vimb";
    tag = version;
    hash = "sha256-NW9B/hybSOaojKIubaxiQ+Nd5f/D4XKxPl9vUyFoX/k=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    gtk3
    libsoup_3
    webkitgtk_4_1
    glib-networking
    gsettings-desktop-schemas
  ];

  passthru = {
    inherit gtk3;
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
