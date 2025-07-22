{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "wpprobe";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "Chocapikk";
    repo = "wpprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-krYUwvFFOl05e/GTdIQvDUkplgcc4/lrWCv8mxmCz9E=";
  };

  vendorHash = "sha256-KV6Ss0fN3xwm5Id7MAHMUjq9TsQbaInLjd5xcLKGX6U=";

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Chocapikk/wpprobe/internal/utils.Version=v${finalAttrs.version}"
  ];

  doInstallCheck = true;

  checkFlags = [
    # Test requires network access
    "-skip=TestUpdateWordfence"
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
