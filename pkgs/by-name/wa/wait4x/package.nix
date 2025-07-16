{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.4.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${version}";
    hash = "sha256-Pb2Klupm6cNYUQ3bWBHwr3NW1HCdit2NFFISn9/c860=";
  };

  vendorHash = "sha256-6gRiYQYtkADBAMNqma4PfuzIttseyE/bHnlkpOgsVjI=";

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
