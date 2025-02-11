{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    tag = "v${version}";
    hash = "sha256-3kRtBfIT6QcdZ1+h2WwvxsAv/UJLtwSodF5zvCUDbHQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4kx3co9doFYD9SjJhL17hgf6ll4niKnF57evv/eNeM0=";

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
