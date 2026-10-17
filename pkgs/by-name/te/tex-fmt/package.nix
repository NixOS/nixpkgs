{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tex-fmt";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7CEYY2wHibE5BK4qzFe3NZKiuKD5aikeBk3+NSJs+G4=";
  };

  cargoHash = "sha256-gHpLSgRLvPJtoPrCtWS1+6bKT0i+86yvjQ5mm59yXsc=";

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
    changelog = "https://github.com/WGUNDERWOOD/tex-fmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tex-fmt";
    maintainers = with lib.maintainers; [ wgunderwood ];
  };
})
