{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tfupdate";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfupdate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Df6imS3JCtMOMCNJd/3cFqK5JsGpIkF/yab7B7YgILI=";
  };

  vendorHash = "sha256-0odAvB2VqYZnPu4wlXpPeR2ioEq3WOGyvpRm72/GWsg=";

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
