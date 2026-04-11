{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taskwarrior-tui";
  version = "0.26.6";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3RUTNQe0D9EquqWowsXI3Ho9mKdckC0XilDcNLmtfCk=";
  };

  cargoHash = "sha256-dXdbvsQ1RJWORZMWsxF///8y1wsar6FiCblHyZD7t8o=";

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
