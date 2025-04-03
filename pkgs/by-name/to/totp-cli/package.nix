{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  pname = "totp-cli";
  version = "1.9.2";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "yitsushi";
    repo = "totp-cli";
    tag = "v${version}";
    hash = "sha256-JPS4LXEgFM+RJhJG9w/SmEYmq6kILie139UrFGyZ2q0=";
  };

  vendorHash = "sha256-GulRmDKatbu4N29Th4rUiVSvvg4hhepyx5X8TLLJ9kQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash autocomplete/bash_autocomplete
    installShellCompletion --zsh autocomplete/zsh_autocomplete
  '';

  meta = {
    description = "Authy/Google Authenticator like TOTP CLI tool written in Go";
    changelog = "https://github.com/yitsushi/totp-cli/releases/";
    homepage = "https://yitsushi.github.io/totp-cli/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "totp-cli";
  };
}
