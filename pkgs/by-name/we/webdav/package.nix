{ lib, fetchFromGitHub, buildGo123Module }:

buildGo123Module rec {
  pname = "webdav";
  version = "5.4.3";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "sha256-ASc+ioVBpCFESEryI0EwKYZln1JzPCOKLJJWmh7L8oA=";
  };

  vendorHash = "sha256-d8WauJ1i429dr79iHgrbFRZCmx+W6OobSINy8aNGG6w=";

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = licenses.mit;
    maintainers = with maintainers; [
      pmy
      pbsds
    ];
    mainProgram = "webdav";
  };
}
