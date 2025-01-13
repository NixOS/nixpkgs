{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  pname = "totp-cli";
  version = "1.8.8";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "yitsushi";
    repo = "totp-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-aYTOtel7ZPDNF8/3mpk/dchBHzoA3ZDnViidQ/N9+As=";
  };

  vendorHash = "sha256-yicJjDFdvQ9EEF37pn3wHuLTVzpmBC8DwexgX7lGmh0=";

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
