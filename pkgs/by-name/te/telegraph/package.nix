{ lib
, desktop-file-utils
, fetchFromGitHub
, gobject-introspection
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "telegraph";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "fkinoshita";
    repo = "Telegraph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m36YHIo1PaDunnC12feSAbwwG1+E7s90fzOKskHtIag=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];

  meta = with lib; {
    changelog = "https://github.com/fkinoshita/Telegraph/releases/v${finalAttrs.version}";
    description = "Write and decode Morse";
    homepage = "https://github.com/fkinoshita/Telegraph";
    license = licenses.gpl3Only;
    mainProgram = "telegraph";
    maintainers = with maintainers; [ michaelgrahamevans ];
    platforms = platforms.linux;
  };
})
