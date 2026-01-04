{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tsshd";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-JNuLN0eA+HSG/Uv5kTgYmOVBSTIBDAJ6vqPa7z+JYTg=";
  };

  vendorHash = "sha256-XjPXbhrMUYObgw0BBYT4BxDoE6THEYXnAZ5y5rUKgh4=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server for `trzsz-ssh`(`tssh`) that supports connection migration for roaming";
    homepage = "https://github.com/trzsz/tsshd";
    changelog = "https://github.com/trzsz/tsshd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ljxfstorm ];
    mainProgram = "tsshd";
  };
})
