{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "syn2mas";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    rev = "v${version}";
    hash = "sha256-s6LVCISmbG3ubY/67DcUUE/pnTJSE0v9n8INmLMQNcw=";
  };

  sourceRoot = "${src.name}/tools/syn2mas";

  npmDepsHash = "sha256-H3N0wm7M9GUvB32fch2TWulmmcU5Cb3SuWLkOkIZBqY=";

  dontBuild = true;

  meta = {
    description = "Tool to help with the migration of a Matrix Synapse installation to the Matrix Authentication Service";
    homepage = "https://github.com/element-hq/matrix-authentication-service/tree/main/tools/syn2mas";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "syn2mas";
  };
}
