{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "webdav";
  version = "5.14.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WoXXLJ2r8YtS91iGJ5XE2wn/TJjkA6kj29INGlplJSA=";
  };

  vendorHash = "sha256-BiEofFnuAcuXQv16RN/lx9+SDUzss++jAmf2ifLJg34=";

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
