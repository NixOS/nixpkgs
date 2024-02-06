{ lib, buildDunePackage, caqti, mariadb }:

buildDunePackage {
  pname = "caqti-driver-mariadb";
  inherit (caqti) version src;

  propagatedBuildInputs = [ caqti mariadb ];

  duneVersion = "3";

  meta = caqti.meta // {
    description = "MariaDB driver for Caqti using C bindings";
  };
}
