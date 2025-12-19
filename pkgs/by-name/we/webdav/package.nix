{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "webdav";
  version = "5.10.2";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
    hash = "sha256-Z+r119dYAJO6HRKgRYtwYII4wSdWgNedZOA6n8h4udM=";
  };

  vendorHash = "sha256-BR7b59FC/UhQdgO5HcxZK8vEe4WXFCHBiKoRqNr4zNY=";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    changelog = "https://github.com/hacdias/webdav/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pmy
      pbsds
    ];
    mainProgram = "webdav";
  };
}
