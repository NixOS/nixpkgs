{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vfox";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "version-fox";
    repo = "vfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iCHvrq1GoW1J6BnslhhFb7M9IE4DGtoXLRrZe2PzlAU=";
  };

  vendorHash = "sha256-+swC2G8g0rrANsUM8jXad+38QX0yWIf+2boyAv7+hG8=";

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags =
    let
      skippedTests = [
        # need network
        "TestGetRequest"
        "TestHeadRequest"
        "TestDownloadFile"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  preCheck = ''
    export CI=1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extendable version manager";
    homepage = "https://github.com/version-fox/vfox";
    changelog = "https://github.com/version-fox/vfox/releases/tag/v${finalAttrs.version}";
    mainProgram = "vfox";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
