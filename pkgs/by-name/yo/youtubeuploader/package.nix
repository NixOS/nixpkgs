{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "youtubeuploader";
  version = "1.24.4";

  src = fetchFromGitHub {
    owner = "porjo";
    repo = "youtubeuploader";
    tag = "v${version}";
    hash = "sha256-93VqB8tnl5o6YRY2cNBF/uARrJI6ywNg83lXGMxtgYM=";
  };

  vendorHash = "sha256-FgAfUcgY2dY8Jj3YcxrIGOpzQeAAICELeKL+scblZq0=";

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
    maintainers = with lib.maintainers; [ srghma ];
    mainProgram = "youtubeuploader";
    platforms = lib.platforms.unix;
  };
}
