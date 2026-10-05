{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "wpprobe";
  version = "0.12.11";

  src = fetchFromGitHub {
    owner = "Chocapikk";
    repo = "wpprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DEDbLnQRAYex6OAHoXRHxE6SQ5C/uTznk7klTosiauk=";
  };

  vendorHash = "sha256-0l7n6u2iODxoVR1fIMyUBaQj7cYk0Q5VnXUePaqOHXc=";

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Chocapikk/wpprobe/internal/version.Version=v${finalAttrs.version}"
  ];

  doInstallCheck = true;

  checkFlags = [
    # Tests require network access
    "-skip=TestUpdateWordfence|TestAPI_Scan|TestAPI_ScanWithContext|TestAPI_ScanWithProgress|TestAPI_UpdateDatabases"
  ];

  meta = {
    description = "WordPress plugin enumeration tool";
    homepage = "https://github.com/Chocapikk/wpprobe";
    changelog = "https://github.com/Chocapikk/wpprobe/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wpprobe";
  };
})
