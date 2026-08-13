{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "webdav";
  version = "5.14.2";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TV3yEVx8KHDPjnrbyB+jW9ajOZMRJWEMLanEmXM/564=";
  };

  vendorHash = "sha256-8peoMHSFDkiOEEnrXR98yIzdf2lDgo3ByrslTdtUooA=";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    changelog = "https://github.com/hacdias/webdav/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pmy
      pbsds
    ];
    mainProgram = "webdav";
  };
})
