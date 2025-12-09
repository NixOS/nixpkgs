{
  stdenv,
  lib,
  fetchFromSourcehut,
  pkg-config,
  meson,
  ninja,
  wayland,
  gtk3,
  wrapGAppsHook3,
  installShellFiles,
}:
stdenv.mkDerivation rec {
  pname = "wofi";
  version = "1.5.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromSourcehut {
    repo = "wofi";
    owner = "~scoopta";
    rev = "v${version}";
    sha256 = "sha256-r+p8WDJw8aO1Gdgy6+UwT5QJdejIjcPFSs/Gfzq+D/c=";
    vc = "hg";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook3
    installShellFiles
  ];
  buildInputs = [
    wayland
    gtk3
  ];

  patches = [
    # https://todo.sr.ht/~scoopta/wofi/121
    ./do_not_follow_symlinks.patch
  ];

  postInstall = ''
    installManPage man/wofi*
  '';

  meta = with lib; {
    description = "Launcher/menu program for wlroots based wayland compositors such as sway";
    homepage = "https://hg.sr.ht/~scoopta/wofi";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    platforms = with platforms; linux;
    mainProgram = "wofi";
  };
}
