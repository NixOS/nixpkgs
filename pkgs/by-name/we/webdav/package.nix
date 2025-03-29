{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "webdav";
  version = "5.7.4";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
    hash = "sha256-f4Z5DiwrcF18ZSfDeSf1kwQIRmVNK4K5WrkQJYfquIs=";
  };

  vendorHash = "sha256-8M25/Pfu175CYsO+bvLN5wxT7OciUUt7iQV0BkezTVw=";

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
