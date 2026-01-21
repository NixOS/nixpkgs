{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "webdav";
  version = "5.10.3";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
    hash = "sha256-HARY25aOiDKkx2kZA+tckOx+320+tWxamLzRbXQIIBE=";
  };

  vendorHash = "sha256-yshwX898P9ZXxKkHLguEPV2h9dibIVaFOYWpONHzzY4=";

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
