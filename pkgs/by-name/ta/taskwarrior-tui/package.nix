{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taskwarrior-tui";
  version = "0.26.5";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mdkGRxe9d92WXBCLhBUWNALS4WwjoeYgZop2frZwNN0=";
  };

  cargoHash = "sha256-Z9y8LLqTicbw4Q+lFalQo4kZFddU2fVMBl6iR4f6D9g=";

  nativeBuildInputs = [ installShellFiles ];

  # Because there's a test that requires terminal access
  doCheck = false;

  postInstall = ''
    installManPage docs/taskwarrior-tui.1
    installShellCompletion completions/taskwarrior-tui.{bash,fish} --zsh completions/_taskwarrior-tui
  '';

  meta = {
    description = "Terminal user interface for taskwarrior";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "taskwarrior-tui";
  };
})
