{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  makeWrapper,
  openssl,
  wl-clipboard,
  xclip,
  xsel,
}:

rustPlatform.buildRustPackage {
  pname = "tiles-tui-file-manager";
  version = "14.61.0";

  src = fetchFromGitHub {
    owner = "DraconDev";
    repo = "tiles";
    tag = "v14.61.0";
    hash = "sha256-Apxfv4u88KuPGxdOXbCZAfvMbqjxAn2Mpsgk/+KaLtQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  cargoHash = "sha256:0000000000000000000000000000000000000000000000000000000000000000";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    wrapProgram "$out/bin/tiles" \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard xclip xsel ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Dual-pane TUI file manager built in Rust";
    longDescription = ''
      A dual-pane TUI file manager with Vim-style navigation, built-in text editor,
      git integration, SSH remote browsing, system monitoring, and smart terminal tab spawning.
    '';
    homepage = "https://github.com/DraconDev/tiles";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tiles";
  };
}