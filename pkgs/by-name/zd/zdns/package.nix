{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "zdns";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zdns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wQXw68Ffa6i09+RkIDUQhIhezDR27eSZ0ppBB8/ihOo=";
  };

  vendorHash = "sha256-yvrIj2XBBWRlhTYl8sveq9eu6LYRo3aMzRy1Jgj7+f0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestConvertNameServerStringToNameServer"
        "TestNetworkConditions"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "CLI DNS lookup tool";
    mainProgram = "zdns";
    homepage = "https://github.com/zmap/zdns";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
