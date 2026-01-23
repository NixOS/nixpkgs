{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  libheif,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "timewall";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = "timewall";
    rev = version;
    hash = "sha256-+jQ8cQENxTgCyekF65tr4d2a7OwbJvagUX01DiJ8ytg=";
  };

  cargoHash = "sha256-HjwBpUhepF2bGQvzIMrNuwjNuh48V+Uv9eS4/ZbxT1c=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ libheif ];

  SHELL_COMPLETIONS_DIR = "completions";

  preBuild = ''
    mkdir ${SHELL_COMPLETIONS_DIR}
  '';

  postInstall = ''
    installShellCompletion \
      --bash ${SHELL_COMPLETIONS_DIR}/timewall.bash \
      --zsh ${SHELL_COMPLETIONS_DIR}/_timewall \
      --fish ${SHELL_COMPLETIONS_DIR}/timewall.fish
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Apple dynamic HEIF wallpapers on GNU/Linux";
    homepage = "https://github.com/bcyran/timewall";
    changelog = "https://github.com/bcyran/timewall/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "timewall";
    maintainers = with lib.maintainers; [ bcyran ];
  };
}
