{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "youtubeuploader";
  version = "1.25.5";

  src = fetchFromGitHub {
    owner = "porjo";
    repo = "youtubeuploader";
    tag = "v${version}";
    hash = "sha256-KG0x2+nTTB+d7Yon2xRdlhEqYr74jNPD4+3dKyccOdc=";
  };

  vendorHash = "sha256-wVfJnN9QgF7c2aI3OghfJW9Z6McZ+irgMRSkWvVi1DM=";

  passthru.updateScript = nix-update-script { };

  ldflags = [
    "-s"
    "-X main.appVersion=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  meta = {
    description = "Scripted uploads to Youtube using Golang";
    homepage = "https://github.com/porjo/youtubeuploader";
    changelog = "https://github.com/porjo/youtubeuploader/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "youtubeuploader";
    platforms = lib.platforms.unix;
  };
}
