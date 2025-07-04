{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "webdav";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
    hash = "sha256-6G9NlQVYFDLuIxKJXq0Rcixx1AiDhTHUekumMNqXi44=";
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
