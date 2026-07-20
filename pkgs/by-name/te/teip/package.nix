{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  perl,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "teip";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = "teip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-isdp0EbHsge5vn4h1rKH2LCLFGp33BXew4SU48QKz7g=";
  };

  cargoHash = "sha256-YEgLNfES9ffxwz+mR+fjDONa2M0JxvKtmoYBORDaY8w=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ perl ];

  # tests are locale sensitive
  preCheck = ''
    export LANG=${if stdenv.hostPlatform.isDarwin then "en_US.UTF-8" else "C.UTF-8"}
  '';

  postInstall = ''
    installManPage man/teip.1
    installShellCompletion \
      --bash completion/bash/teip \
      --fish completion/fish/teip.fish \
      --zsh completion/zsh/_teip
  '';

  meta = {
    description = "Tool to bypass a partial range of standard input to any command";
    mainProgram = "teip";
    homepage = "https://github.com/greymd/teip";
    changelog = "https://github.com/greymd/teip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
