{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vfox";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "version-fox";
    repo = "vfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pPsHR4kO4/b0VDz7y+iMwalJibjAzu6A2QwkBMTys7E=";
  };

  vendorHash = "sha256-494nqL6KiUk4VeKlG9YHFpgACgaYC3SR1I1EViD71Jw=";

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
