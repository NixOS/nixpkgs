{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.9.73";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-KDw6axnjwMnXeTKaG2GIF2C4dKiZ/MW2q0SlZGlBIoI=";
  };

  npmDepsHash = "sha256-U7gZNKUIU3wS8DaVdxi1/Ik+dzwPfyoI3m//2MgPvt4=";

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
