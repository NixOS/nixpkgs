{
  buildDunePackage,
  caqti,
  sqlite3,
  alcotest,
  dune-site,
}:

buildDunePackage {
  pname = "caqti-driver-sqlite3";
  inherit (caqti) version src;

  propagatedBuildInputs = [
    caqti
    sqlite3
  ];

  checkInputs = [
    alcotest
    dune-site
  ];

  doCheck = true;

  meta = caqti.meta // {
    description = "Sqlite3 driver for Caqti using C bindings";
  };
}
