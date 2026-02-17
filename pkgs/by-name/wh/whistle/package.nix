{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-KnKrucpWXJuNErMbKLuI/C2GjROVdJ7wrEZ58b2GX50=";
  };

  npmDepsHash = "sha256-AqCGaX/R2IggS2gHiruXc8xoK9tU4eIkaMNLlYqWwM4=";

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
