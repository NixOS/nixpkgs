{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.2.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UVs8tCOgPU/IwM3Z3/ehFnAbHTSOHGAO9VpcB/NItGM=";
  };

  vendorHash = "sha256-lwNRRWpo2Fkpoc42URrqSLFKSGN7IfuD4759KB0uEgM=";

  # Tests make network access
  doCheck = false;

  meta = with lib; {
    description = "Wait4X allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/wait4x/wait4x";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
}
