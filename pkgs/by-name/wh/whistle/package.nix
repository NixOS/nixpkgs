{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.9.92";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-pIOVVCoyC6j8QeNDlls9EpDwKUpBLbFuxL2bMpSog5A=";
  };

  npmDepsHash = "sha256-z4w5JQdGuWu7z3rWYLO83uCrrSjt2wKbhRUGgrduoOc=";

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
