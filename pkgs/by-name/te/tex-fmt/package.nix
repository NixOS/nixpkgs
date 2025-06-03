{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    tag = "v${version}";
    hash = "sha256-CAuhIJbe483Qu+wnNfXTkQ3ERAbkt07QzZ7z7pcbl10=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZXoaQYUYut11r6zvvIihZ3myL4B4y5yKq6P1BBtky/c=";

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
