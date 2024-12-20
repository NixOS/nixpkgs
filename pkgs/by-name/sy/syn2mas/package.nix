{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "syn2mas";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    rev = "v${version}";
    hash = "sha256-QLtyYxV2yXHJtwWgGcyi7gRcKypYoy9Z8bkEuTopVXc=";
  };

  sourceRoot = "${src.name}/tools/syn2mas";

  npmDepsHash = "sha256-pRa5qqLsI8Hx9v5tMPDkehczXZjWWAOjfDfLLh2V6Q4=";

  dontBuild = true;

  meta = {
    description = "Tool to help with the migration of a Matrix Synapse installation to the Matrix Authentication Service";
    homepage = "https://github.com/element-hq/matrix-authentication-service/tree/main/tools/syn2mas";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "syn2mas";
  };
}
