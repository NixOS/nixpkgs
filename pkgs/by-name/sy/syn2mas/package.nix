{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "syn2mas";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-authentication-service";
    rev = "v${version}";
    hash = "sha256-foipChunzRKIbeO+O+XYx0luzaA0G9LKrH59luQl9R0=";
  };

  sourceRoot = "source/tools/syn2mas";

  npmDepsHash = "sha256-CdEjfT4rXINv0Fzy56T//XftuAzrn03lQd76/PC2QR8=";

  dontBuild = true;

  meta = with lib; {
    description = "Tool to help with the migration of a Matrix Synapse installation to the Matrix Authentication Service";
    homepage = "https://github.com/matrix-org/matrix-authentication-service/tree/main/tools/syn2mas";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
    mainProgram = "syn2mas";
  };
}
