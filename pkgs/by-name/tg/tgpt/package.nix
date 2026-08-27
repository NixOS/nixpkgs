{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libx11,
}:

buildGoModule (finalAttrs: {
  pname = "tgpt";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-70BbII+cK9s+5yIFmpUV3pNqiTPSWfwLbrwNvvjkXrA=";
  };

  vendorHash = "sha256-oh1qKEmWoWK9fXgSfbHFgM8TWD14xNNRFw+YgqnXt00=";

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
