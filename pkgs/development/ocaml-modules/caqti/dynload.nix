{ lib, buildDunePackage, caqti }:

buildDunePackage {
  pname = "caqti-dynload";
  inherit (caqti) version src;

  propagatedBuildInputs = [ caqti ];

  meta = caqti.meta // {
    description = "Dynamic linking of Caqti drivers using findlib.dynload";
  };
}
