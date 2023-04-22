{ lib, buildDunePackage, caqti, findlib }:

buildDunePackage {
  pname = "caqti-dynload";
  inherit (caqti) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ caqti findlib ];

  meta = caqti.meta // {
    description = "Dynamic linking of Caqti drivers using findlib.dynload";
  };
}
