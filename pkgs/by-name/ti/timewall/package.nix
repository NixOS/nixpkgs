{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  libheif,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "timewall";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = "timewall";
    tag = finalAttrs.version;
    hash = "sha256-6tcIFdDJ297EbP/2wF1AR95Gb4z5ygbjNIT94ccIgxQ=";
  };

  cargoHash = "sha256-hM8sTzYqoybSO3I2cwUpQE0YOO9PEBNYndR1o1+Bx/U=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ libheif ];

  env.SHELL_COMPLETIONS_DIR = "completions";

  preBuild = ''
    mkdir $SHELL_COMPLETIONS_DIR
  '';

  postInstall = ''
    installShellCompletion \
      --bash $SHELL_COMPLETIONS_DIR/timewall.bash \
      --zsh $SHELL_COMPLETIONS_DIR/_timewall \
      --fish $SHELL_COMPLETIONS_DIR/timewall.fish
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Apple dynamic HEIF wallpapers on GNU/Linux";
    homepage = "https://github.com/bcyran/timewall";
    changelog = "https://github.com/bcyran/timewall/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "timewall";
    maintainers = with lib.maintainers; [ bcyran ];
  };
})
