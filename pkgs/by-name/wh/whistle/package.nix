{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.10.15";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-lI7I6CqMV1A7LF1XoNYTGoameLQxuIpS+tyivf99y5M=";
  };

  npmDepsHash = "sha256-MP4aqrU37hy3GQ1y0ObzJosi+/P7/5tYELXMeSVqTe4=";

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
