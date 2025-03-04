{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.0.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "atkrad";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w/ruvlvHoKO42YRrc7x8vUtkoVM1QMASNwptdmZTL1M=";
  };

  vendorHash = "sha256-ODcHrmmHHeZbi1HVDkYPCyHs7mcs2UGdBzicP1+eOSI=";

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
