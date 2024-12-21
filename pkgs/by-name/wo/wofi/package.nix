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
  version = "1.4.1";

  src = fetchFromSourcehut {
    repo = pname;
    owner = "~scoopta";
    rev = "v${version}";
    sha256 = "sha256-aedoUhVfk8ljmQ23YxVmGZ00dPpRftW2dnRAgXmtV/w=";
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
