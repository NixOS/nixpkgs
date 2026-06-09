{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitUpdater,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tkey-ssh-agent";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tillitis";
    repo = "tkey-ssh-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ndS9eNxhZTCxaxEF/J3FzIA8xtlVdbm9q9W1I9lC8+k=";
  };

  vendorHash = "sha256-+JTGgiCLvJsju3gbqbid6TZCfSgjPySfeaEtiyuTlWM=";

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
