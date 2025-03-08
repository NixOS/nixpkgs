{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "syn2mas";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    rev = "v${version}";
    hash = "sha256-k+om7LfHcVr5ugJAXicFIcz2CNGGEzVb+O8uXdVukpE=";
  };

  sourceRoot = "${src.name}/tools/syn2mas";

  npmDepsHash = "sha256-n/YkWm4JoXAY6smULQNQDTHGtYkPBXsxfo3BU05zIbA=";

  dontBuild = true;

  meta = {
    description = "Tool to help with the migration of a Matrix Synapse installation to the Matrix Authentication Service";
    homepage = "https://github.com/element-hq/matrix-authentication-service/tree/main/tools/syn2mas";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "syn2mas";
  };
}
