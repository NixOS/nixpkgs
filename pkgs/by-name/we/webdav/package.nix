{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "webdav";
  version = "5.15.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W3zvXL90I271FdapZggA6YMsqjbc6Umbqh/u5ly9FdQ=";
  };

  vendorHash = "sha256-k3616W8xjTCNZLCL38J4CcX272BhgpC59mUAWderIFM=";

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
