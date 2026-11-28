{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tfupdate";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfupdate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-81kk7ltv7K+iBFUCtjYWYiuMwE80iRXsEYC92PlOMhU=";
  };

  vendorHash = "sha256-5dz76K1/sBmms1iL7dFHXg2jJwsRmDlgstiHKExBAyU=";

  # Go 1.27 changed DEFLATE output, breaking the hardcoded hashes of the generated ZIP fixtures.
  # https://go.dev/doc/go1.27#compressflatepkgcompressflate
  checkFlags =
    let
      skippedTests = [
        "TestShaSumsDataToZhHash"
        "TestProviderIndexGetOrCreateProviderVersion"
        "TestBuildProviderVersionFromDownload"
        "TestProviderLockClientProviderDownload"
        "TestValidateSHA256Sum"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Update version constraints in your Terraform configurations";
    mainProgram = "tfupdate";
    homepage = "https://github.com/minamijoyo/tfupdate";
    changelog = "https://github.com/minamijoyo/tfupdate/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Intuinewin
      qjoly
    ];
  };
})
