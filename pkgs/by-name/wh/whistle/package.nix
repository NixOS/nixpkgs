{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.9.65";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-vF81Nt0gx3k7b6VO6aBpeUSnZ8Op91dYOGZRO9cdleM=";
  };

  npmDepsHash = "sha256-LzetbeIqfcFbLzie4GXkNOGLTdwqYMnwZ236V5R2TNc=";

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
