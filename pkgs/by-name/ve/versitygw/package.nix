{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "versitygw";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XdBIDSiBJVpiQgpQXI0qIbaqFVswxEoXGze2Nxes3lg=";
  };

  vendorHash = "sha256-z+m5ez17yF+GcUHyKU6a3Q69A6ACBVk0gCjKIaIJ554=";

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
