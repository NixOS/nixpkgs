{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitUpdater,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tkey-ssh-agent";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tillitis";
    repo = "tkey-ssh-agent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uf3VJJfZn4UYX1q79JdaOfrore+L/Mic3whzpP32JV0=";
  };

  vendorHash = "sha256-SFyp1UB6+m7/YllRyY56SwweJ3X175bChXQYiG2M7zM=";

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

  meta = with lib; {
    description = "SSH Agent for TKey, the flexible open hardware/software USB security key";
    homepage = "https://tillitis.se/app/tkey-ssh-agent/";
    changelog = "https://github.com/tillitis/tkey-ssh-agent/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "tkey-ssh-agent";
    platforms = platforms.all;
  };
})
