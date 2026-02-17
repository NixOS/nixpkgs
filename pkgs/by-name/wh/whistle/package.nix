{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = "whistle";
    rev = "v${version}";
    hash = "sha256-hx6TGi8ZQ16FczqMWLa6qXbwsdJf8sVgJR8scmfgucQ=";
  };

  npmDepsHash = "sha256-+v60LaJqwbN0g9oBTCcI0ZuhKiS700QRHfgKf6Fuo8Y=";

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
