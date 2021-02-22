{ lib, buildDunePackage, caqti, mariadb }:

buildDunePackage {
  pname = "caqti-driver-mariadb";
  useDune2 = true;
  inherit (caqti) version src;

  propagatedBuildInputs = [ caqti mariadb ];

  meta = caqti.meta // {
    description = "MariaDB driver for Caqti using C bindings";
  };
}
