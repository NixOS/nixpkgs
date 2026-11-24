{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yaegi";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "yaegi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AzWlp2yiDRdChmm72qUqDGzm09xVHcOZYHpS1tY/YR0=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/yaegi"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    # Yaegi v2 (v2.x tags) is a new, experimental engine; v0.x stays the stable line
    extraArgs = [
      "--version-regex"
      "v(0\\..*)"
    ];
  };

  meta = {
    description = "Go interpreter";
    mainProgram = "yaegi";
    homepage = "https://github.com/traefik/yaegi";
    changelog = "https://github.com/traefik/yaegi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
})
