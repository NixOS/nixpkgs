{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "timescaledb-tune";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HCl0v9hS9/UgzLniFQ7QFb5pdOAnnoomT3Zv3BLf/Ac=";
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
