{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "sha256-8PFGlsm9B6qHRrY7YIPwknmGS+Peg5MWd0kMT173wIQ=";
  };

  cargoHash = "sha256-Cd319GCvdh6S8OO2ylKs1H2+zO4Uq1tgNakghVD12BA=";

  nativeBuildInputs = [ installShellFiles ];

  # Because there's a test that requires terminal access
  doCheck = false;

  postInstall = ''
    installManPage docs/taskwarrior-tui.1
    installShellCompletion completions/taskwarrior-tui.{bash,fish} --zsh completions/_taskwarrior-tui
  '';

  meta = with lib; {
    description = "Terminal user interface for taskwarrior";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "taskwarrior-tui";
  };
}
