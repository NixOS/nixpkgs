{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "syn2mas";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-authentication-service";
    rev = "v${version}";
    hash = "sha256-DPGigs6DifTRa7VQVHgizZ3BUy3FPX3YhZi++yoBFBA=";
  };

  sourceRoot = "${src.name}/tools/syn2mas";

  npmDepsHash = "sha256-HvBFuRyP1APg5V+yhvlODAJ02MEkdpuLfNjWB/UT2vg=";

  dontBuild = true;

  meta = with lib; {
    description = "Tool to help with the migration of a Matrix Synapse installation to the Matrix Authentication Service";
    homepage = "https://github.com/matrix-org/matrix-authentication-service/tree/main/tools/syn2mas";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
    mainProgram = "syn2mas";
  };
}
