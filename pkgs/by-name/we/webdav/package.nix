{ lib, fetchFromGitHub, buildGo123Module }:

buildGo123Module rec {
  pname = "webdav";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
    hash = "sha256-nLQ77RuOGYaL+U3X3yb4Kq47NA1A3SSUMKBbFnRP6o4=";
  };

  vendorHash = "sha256-x5CUy46c4SunzMw/v2DWpdahuXFZnJdGInQ0lSho/es=";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pmy
      pbsds
    ];
    mainProgram = "webdav";
  };
}
