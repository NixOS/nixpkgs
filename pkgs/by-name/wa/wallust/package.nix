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
  version = "3.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = finalAttrs.version;
    hash = "sha256-n3FXPlm8nructXh+Wc7BgJvxas6OFHEPbTe2QWjEpsg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LIHSnRPrx4gHZkpKEEZ1Um609i3vv0JGXLpbiSD08P4=";

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
