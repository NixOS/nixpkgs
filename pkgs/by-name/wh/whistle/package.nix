{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.9.80";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-nBjVPWs9ZTs35UHysITlJc/SEA7nJ16ZF7qWQGzrp70=";
  };

  npmDepsHash = "sha256-kWlScRM6vkSQgH3Z4voIsjV+wRbaKL4ApSdP58u9cxg=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "HTTP, HTTP2, HTTPS, Websocket debugging proxy";
    homepage = "https://github.com/avwo/whistle";
    changelog = "https://github.com/avwo/whistle/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "whistle";
  };
}
