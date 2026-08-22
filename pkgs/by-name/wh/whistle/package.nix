{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.10.7";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-l2FSoCizrlxZ4Z1wdB/cQLCh1pgqSf7kZHCqEpw2P7M=";
  };

  npmDepsHash = "sha256-NbBDR3tgQS4vAmtCnukl6srFVcwD9gIKO68KgKGDPTw=";

  dontNpmBuild = true;

  meta = {
    description = "HTTP, HTTP2, HTTPS, Websocket debugging proxy";
    homepage = "https://github.com/avwo/whistle";
    changelog = "https://github.com/avwo/whistle/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "whistle";
  };
}
