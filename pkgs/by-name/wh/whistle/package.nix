{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.9.105";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-Ho9TRVoLEQ/vvQ9VEtpgCJdY/KnXQiplYecL8wqCAr0=";
  };

  npmDepsHash = "sha256-OCFjMo/NNsxpWxxZzEFQ3tJwA4tDGk6fY0Gj3LnZHBY=";

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
