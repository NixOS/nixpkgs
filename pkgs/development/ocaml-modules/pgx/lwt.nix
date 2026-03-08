{
  buildDunePackage,
  logs,
  lwt,
  pgx,
}:

buildDunePackage (finalAttrs: {
  pname = "pgx_lwt";
  inherit (pgx) version src;

  propagatedBuildInputs = [
    logs
    lwt
    pgx
  ];

  doCheck = true;

  meta = pgx.meta // {
    description = "Pgx using Lwt for IO";
  };
})
