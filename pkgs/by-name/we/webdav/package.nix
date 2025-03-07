{ lib, fetchFromGitHub, buildGo123Module }:

buildGo123Module rec {
  pname = "webdav";
  version = "5.7.3";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
    hash = "sha256-f/EYuaLuF9HuoC2S4JHjtgau2ZmOocRIAtxXqnUpUE8=";
  };

  vendorHash = "sha256-x5CUy46c4SunzMw/v2DWpdahuXFZnJdGInQ0lSho/es=";

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
