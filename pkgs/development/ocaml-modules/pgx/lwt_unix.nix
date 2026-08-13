{
  alcotest-lwt,
  base64,
  buildDunePackage,
  pgx,
  pgx_lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "pgx_lwt_unix";
  inherit (pgx) version src;

  propagatedBuildInputs = [ pgx_lwt ];

  checkInputs = [
    alcotest-lwt
    base64
  ];
  doCheck = true;

  meta = pgx.meta // {
    description = "Pgx using Lwt and Unix libraries for IO";
  };
})
