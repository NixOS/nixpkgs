{ lib
, buildGoModule
, fetchFromGitHub
}:
let
  pname = "wait4x";
  version = "2.14.2";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "atkrad";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fNPZ/qgAn4odd5iWnDK1RWPxeBhS/l4ffHLFB27SAoM=";
  };

  vendorHash = "sha256-Eio6CoYaChG59rHL4tfl7dNWliD7ksRyhoCPxMvMmrQ=";

  # Tests make network access
  doCheck = false;

  meta = with lib; {
    description = "Wait4X allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/atkrad/wait4x";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
}
