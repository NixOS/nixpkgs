{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vt-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "vt-cli";
    tag = finalAttrs.version;
    hash = "sha256-XvAS329O4XYseUqbleEyP4ozherI/apMw8Zx0ZVQZsc=";
  };

  vendorHash = "sha256-s90a35fFHO8Tt7Zjf9bk1VVD2xhG1g4rKmtIuMl0bMQ=";

  ldflags = [ "-X github.com/VirusTotal/vt-cli/cmd.Version=${finalAttrs.version}" ];

  subPackages = [ "vt" ];

  meta = {
    description = "VirusTotal Command Line Interface";
    homepage = "https://github.com/VirusTotal/vt-cli";
    changelog = "https://github.com/VirusTotal/vt-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "vt";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
