{
  lib,
  fetchFromGitea,
  rustPlatform,
  nix-update-script,
  imagemagick,
  makeWrapper,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wallust";
  version = "3.5.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = finalAttrs.version;
    hash = "sha256-ZgkeM9gMw9TB5NR+xyxBepKHO16bLVVFJN4IY39gllg=";
  };

  cargoHash = "sha256-XrIi+8p2OZ7O6MTgqKbgN/9gLUbvB7uN9Yr2X1BYHIU=";

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
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${finalAttrs.version}";
    mainProgram = "wallust";
  };
})
