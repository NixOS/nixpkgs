{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tfupdate";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfupdate";
    rev = "v${version}";
    sha256 = "sha256-wn73AMoIEH8lt9ZmQFv2y3tqXRyiv4yK/rdst7UVHN4=";
  };

  vendorHash = "sha256-e4ZDE25tCLNAaAJNz8fBOr+ankMNCtDvbd9L11DSWBY=";

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Update version constraints in your Terraform configurations";
    mainProgram = "tfupdate";
    homepage = "https://github.com/minamijoyo/tfupdate";
    changelog = "https://github.com/minamijoyo/tfupdate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      Intuinewin
      qjoly
    ];
  };
}
