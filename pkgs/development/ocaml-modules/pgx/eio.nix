{
  alcotest,
  base64,
  buildDunePackage,
  eio,
  eio_main,
  pgx,
}:

buildDunePackage (finalAttrs: {
  pname = "pgx_eio";
  inherit (pgx) version src;

  propagatedBuildInputs = [
    eio
    pgx
  ];

  checkInputs = [
    alcotest
    base64
    eio_main
  ];
  doCheck = true;

  meta = pgx.meta // {
    description = "Pgx using Eio for IO";
  };
})
