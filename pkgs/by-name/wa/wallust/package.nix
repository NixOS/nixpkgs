{
  lib,
  fetchFromGitea,
  rustPlatform,
  nix-update-script,
  imagemagick,
  makeWrapper,
  installShellFiles,
}:
let
  version = "3.1.0";
in
rustPlatform.buildRustPackage {
  pname = "wallust";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = version;
    hash = "sha256-Tad+zyhmTr734GEW0A4SNrfWzqcL0gLFsM6MoMrV17k=";
  };

  cargoHash = "sha256-SEaq0qeWuDeIeCqz9imb5nV4WK44CF5wIwG62nhyqlU=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = ''
    installManPage man/wallust*
    installShellCompletion --cmd wallust \
      --bash completions/wallust.bash \
      --zsh completions/_wallust \
      --fish completions/wallust.fish
  '';

  postFixup = ''
    wrapProgram $out/bin/wallust \
      --prefix PATH : "${lib.makeBinPath [ imagemagick ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      onemoresuza
      iynaix
    ];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    mainProgram = "wallust";
  };
}
