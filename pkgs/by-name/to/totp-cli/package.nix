{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  pname = "totp-cli";
  version = "1.8.7";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "yitsushi";
    repo = "totp-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-WCPDrKGIRrYJFeozXtf8YPgHJ8m6DAsMBD8Xgjvclvc=";
  };

  vendorHash = "sha256-VTlSnw3TyVOQPU+nMDhRtyUrBID2zesGeG2CgDyjwWY=";

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
