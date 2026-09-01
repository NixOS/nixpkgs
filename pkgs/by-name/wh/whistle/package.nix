{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-Rql8aSUVZiKbLOZFpIN8GCadloeNcab84mrRJzopV6k=";
  };

  npmDepsHash = "sha256-uY6a4suEPSwWtZTs4gutd38gwm+9Tef6LX+GPoqUQrA=";

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
