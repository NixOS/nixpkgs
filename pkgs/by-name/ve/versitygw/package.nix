{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "versitygw";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UW6/OfGqX3Y1ddWVQ6w+pdFeOIuE4j5p9JkuZ05HN1o=";
  };

  vendorHash = "sha256-0AgO5A6kdcQluw8NVHsKVuhuOinwGURHUGbKcpbaIPw=";

  subPackages = [ "./cmd/versitygw" ];

  # Require access to online S3 services
  doCheck = false;

  # Needed for "versitygw --version" to not show placeholders
  ldflags = [
    "-X main.Build=v${finalAttrs.version}"
    "-X main.BuildTime=1980-01-01T00:00:02Z"
    "-X main.Version=v${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Versity S3 gateway, a high-performance S3 translation service";
    homepage = "https://github.com/versity/versitygw";
    changelog = "https://github.com/versity/versitygw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "versitygw";
  };
})
