{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "webdav";
  version = "5.7.5";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
    hash = "sha256-iXU3ePALas/Z4caB1uhc5yW88zV/4iqv7qpOw4ZgZ3g=";
  };

  vendorHash = "sha256-B78O13FPpkcuE808c2hLiIDPQdS5qlaw1dWLc9T7hvM=";

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
