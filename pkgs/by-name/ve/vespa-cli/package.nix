{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vespa-cli";
  version = "8.697.20";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vespa-engine";
    repo = "vespa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h2dwCScX0LVd5hV1fnhKjXQue/ywmqyk5t/vzEDAwQE=";
  };

  # case-insensitive conflicts which produce platform `vendorHash` checksumm
  proxyVendor = true;

  sourceRoot = "${finalAttrs.src.name}/client/go";

  vendorHash = "sha256-lrMGxMzUdr2ZlTn13AGwzHZBHUDonmoSxmUIo7cWx3g=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/vespa-engine/vespa/client/go/internal/build.Version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      skippedTests = [
        # these tests try to call home
        "TestAuthShow/auth_show"
        "TestDeployCloud"
        "TestDeployCloudFastWait"
        "TestDeployCloudUnauthorized"
        "TestDestroy"
        "TestLogCloud"
        "TestProdDeploy"
        "TestProdDeployInvalidZip"
        "TestProdDeployWarnsOnInstance"
        "TestProdDeployWithJava"
        "TestProdDeployWithWait"
        "TestProdDeployWithoutCertificate"
        "TestProdDeployWithoutTests"
        "TestSingleTestWithCloudAndEndpoints"
        "TestSingleTestWithCloudAndTokenAuth"
        "TestStatusCloudDeployment"
        # tries to call home for most recent version but we have our own test
        "TestVersion"
        "TestVersionCheckHomebrew"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for Vespa.ai";
    downloadPage = "https://github.com/vespa-engine/vespa/blob/v${finalAttrs.version}/client/go";
    changelog = "https://github.com/vespa-engine/vespa/releases/tag/v${finalAttrs.version}";
    homepage = "https://vespa.ai/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "vespa";
  };
})
