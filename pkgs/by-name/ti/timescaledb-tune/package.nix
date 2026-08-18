{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "timescaledb-tune";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb-tune";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3jsRI/ZuFNxjDfRzWQWclUiuC2qrxtUxJ0gcmXXQLUw=";
  };

  vendorHash = "sha256-7u3eceVDnzjhGguijJXbm40qyCPO/Q101Zr5vEcGEqs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool for tuning your TimescaleDB for better performance";
    mainProgram = "timescaledb-tune";
    homepage = "https://github.com/timescale/timescaledb-tune";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
