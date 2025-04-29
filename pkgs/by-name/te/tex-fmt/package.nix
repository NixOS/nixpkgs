{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    tag = "v${version}";
    hash = "sha256-gBDZeBR1zvVQgpjVh94awTB1TREnGThwIQG2fLm05po=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YeAbDH/ePUQYtp3aQP+SmkXhZY6NopPTmEwvTFuBnks=";

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
