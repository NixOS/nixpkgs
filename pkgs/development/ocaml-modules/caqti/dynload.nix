{ lib, buildDunePackage, caqti }:

buildDunePackage {
  pname = "caqti-dynload";
  useDune2 = true;
  inherit (caqti) version src;

  propagatedBuildInputs = [ caqti ];

  meta = caqti.meta // {
    description = "Dynamic linking of Caqti drivers using findlib.dynload";
  };
}
