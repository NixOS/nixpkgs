{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libx11,
}:

buildGoModule (finalAttrs: {
  pname = "tgpt";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pEJAdpRZIhxTMDIfEmh+el4Uq7Qm6MISqXfU3Daqx74=";
  };

  vendorHash = "sha256-kZkOTu8a5DxifutBJz8EO+5yK9vt0HYzYtmy5Z8hFIA=";

  buildInputs = [ libx11 ];

  ldflags = [ "-s" ];

  checkFlags =
    let
      skippedTests = [
        "TestDetectPackageManager/Scoop_on_Windows"
        "TestDetectPackageManager/Chocolatey_on_Windows"
        "TestRequest"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tgpt";
  };
})
