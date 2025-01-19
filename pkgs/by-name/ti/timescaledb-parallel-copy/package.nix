{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "timescaledb-parallel-copy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HxaGKJnLZjPPJXoccAx0XUsCrZiG09c40zeSbHYXm04=";
  };

  vendorHash = "sha256-muxtr80EjnRoHG/TCEQwrBwlnARsfqWoYlR0HavMe6U=";

  meta = {
    description = "Bulk, parallel insert of CSV records into PostgreSQL";
    mainProgram = "timescaledb-parallel-copy";
    homepage = "https://github.com/timescale/timescaledb-parallel-copy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
