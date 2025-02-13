{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "syn2mas";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    rev = "v${version}";
    hash = "sha256-rFex6stw++xNrcCYnYn3N0HrUQd91DAw9QU0R2MUzyQ=";
  };

  sourceRoot = "${src.name}/tools/syn2mas";

  npmDepsHash = "sha256-liwFM3HkZtZTJmaqF/7WvYxf2EKgjNF5xCHP/OxFK/k=";

  dontBuild = true;

  meta = {
    description = "Tool to help with the migration of a Matrix Synapse installation to the Matrix Authentication Service";
    homepage = "https://github.com/element-hq/matrix-authentication-service/tree/main/tools/syn2mas";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "syn2mas";
  };
}
