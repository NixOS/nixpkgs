{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vfox";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "version-fox";
    repo = "vfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lVhw2OB4TVkqYbI+kGvBX2RMisc+1aF3Sl6z/kshmZE=";
  };

  vendorHash = "sha256-+5hJMip3wAR1k6n21I3QFYe++nw4J4Ip+43EujQl2ec=";

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
