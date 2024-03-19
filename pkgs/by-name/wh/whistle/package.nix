{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.9.66";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-bKHpbTdKFbeQGPl2HFcXi6y27s0JylyUXKg9oAcuSXo=";
  };

  npmDepsHash = "sha256-34KrqF534igGsLfOUxJN5dhtj2rrKGbkUUWr6p7V/Go=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "HTTP, HTTP2, HTTPS, Websocket debugging proxy";
    homepage = "https://github.com/avwo/whistle";
    changelog = "https://github.com/avwo/whistle/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "whistle";
  };
}
