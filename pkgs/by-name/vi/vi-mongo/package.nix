{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "vi-mongo";
  version = "0.1.29";

  src = fetchFromGitHub {
    owner = "kopecmaciej";
    repo = "vi-mongo";
    tag = "v${version}";
    hash = "sha256-hxQPqTQ+U6ebTv6HZReiWMeP8RoyjQC0pA3Qug1MSFo=";
  };

  vendorHash = "sha256-QoYjNzWWNrEDS4Xq1NF77iqX5WTNxnVV1UJiYq2slhw=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kopecmaciej/vi-mongo/cmd.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MongoDB TUI manager designed to simplify data visualization and quick manipulation";
    homepage = "https://github.com/kopecmaciej/vi-mongo";
    changelog = "https://github.com/kopecmaciej/vi-mongo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "vi-mongo";
  };
}
