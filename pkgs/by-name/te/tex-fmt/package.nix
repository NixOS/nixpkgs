{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    tag = "v${version}";
    hash = "sha256-xVB4y80BFa9MRBsMYMSQmaRSNJVoeCiYW2UTJ+UpBYQ=";
  };

  cargoHash = "sha256-glaD8/CoHrtqRnZh0iMR55EQF9xbBbv+x+xt/xa1xTM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/tex-fmt.1
    installShellCompletion \
      --bash completion/tex-fmt.bash \
      --fish completion/tex-fmt.fish \
      --zsh completion/_tex-fmt
  '';

  meta = {
    description = "LaTeX formatter written in Rust";
    homepage = "https://github.com/WGUNDERWOOD/tex-fmt";
    changelog = "https://github.com/WGUNDERWOOD/tex-fmt/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "tex-fmt";
    maintainers = with lib.maintainers; [ wgunderwood ];
  };
}
