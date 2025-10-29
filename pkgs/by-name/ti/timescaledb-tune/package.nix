{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-tune";
    rev = "v${version}";
    sha256 = "sha256-SC91yO3P2Q2QachSfAAzz7ldcnZedZfcnVXHcFXNrIk=";
  };

  vendorHash = "sha256-7u3eceVDnzjhGguijJXbm40qyCPO/Q101Zr5vEcGEqs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool for tuning your TimescaleDB for better performance";
    mainProgram = "timescaledb-tune";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
