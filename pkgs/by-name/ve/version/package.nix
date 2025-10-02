{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "version";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "asciimoth";
    repo = "version";
    rev = "v${version}";
    hash = "sha256-TOmShw4nRyTWv2F0/p9X5WHjLSUz/dYCkp6/+NrILGo=";
  };

  vendorHash = "sha256-TGrtVY1ut76K2J/dpt3OvuXaOkAAnxFTYVl1aTii+AI=";

  postInstall = ''
    mkdir -p $out/share/man/man1
    install -Dm644 man/version.1 $out/share/man/man1/version.1
  '';

  meta = {
    description = "Multi-source semantic version management tool ";
    homepage = "https://github.com/asciimoth/version";
    maintainers = with lib.maintainers; [ asciimoth ];
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "version";
  };
}
