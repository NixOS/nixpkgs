{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.3.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${version}";
    hash = "sha256-3s+ug4KqFv1P55eqNfAB2jbSPVzySxlHmkDMuuVlJcQ=";
  };

  vendorHash = "sha256-dN7R2d7roA6H9wIz2sBaWctD8K6M8nbQbwPc3t/7rlk=";

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
