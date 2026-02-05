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
stdenv.mkDerivation (finalAttrs: {
  pname = "wofi";
  version = "1.5.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromSourcehut {
    repo = "wofi";
    owner = "~scoopta";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-j0KkmRfTRYpzfqHdIsOXk+pYHCrdzICD1Dm847C5ihs=";
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

  meta = {
    description = "Launcher/menu program for wlroots based wayland compositors such as sway";
    homepage = "https://hg.sr.ht/~scoopta/wofi";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = with lib.platforms; linux;
    mainProgram = "wofi";
  };
})
