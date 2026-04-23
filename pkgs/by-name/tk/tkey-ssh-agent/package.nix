{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitUpdater,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tkey-ssh-agent";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tillitis";
    repo = "tkey-ssh-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VwhWIQ+ZTwYD3NwxCImrtK49+i31Cc7xBjx5Cxvm+PA=";
  };

  vendorHash = "sha256-/lSC2+TjG2Ps9t8BbcgXIFWeFykszJM3hr2DqSrnkO8=";

  subPackages = [
    "cmd/tkey-ssh-agent"
  ];

  ldflags = [
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "SSH Agent for TKey, the flexible open hardware/software USB security key";
    homepage = "https://tillitis.se/app/tkey-ssh-agent/";
    changelog = "https://github.com/tillitis/tkey-ssh-agent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "tkey-ssh-agent";
    platforms = lib.platforms.all;
  };
})
