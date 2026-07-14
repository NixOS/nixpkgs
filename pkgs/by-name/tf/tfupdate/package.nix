{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tfupdate";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfupdate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1okamMftP12ggQWxTgkjD4iAuxLlQ0YSwiUq8U39D7Y=";
  };

  vendorHash = "sha256-5dz76K1/sBmms1iL7dFHXg2jJwsRmDlgstiHKExBAyU=";

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
