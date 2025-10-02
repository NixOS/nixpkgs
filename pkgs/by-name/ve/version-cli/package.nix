{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "version-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "asciimoth";
    repo = "version";
    rev = "v${version}";
    hash = "sha256-TOmShw4nRyTWv2F0/p9X5WHjLSUz/dYCkp6/+NrILGo=";
  };

  vendorHash = "sha256-TGrtVY1ut76K2J/dpt3OvuXaOkAAnxFTYVl1aTii+AI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/version.1
  '';

  meta = {
    description = "Multi-source semantic version management tool";
    homepage = "https://github.com/asciimoth/version";
    maintainers = with lib.maintainers; [ asciimoth ];
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "version";
  };
}
