{ lib, buildDunePackage, caqti, postgresql }:

buildDunePackage {
  pname = "caqti-driver-postgresql";
  inherit (caqti) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ caqti postgresql ];

  meta = caqti.meta // {
    description = "PostgreSQL driver for Caqti based on C bindings";
  };
}
