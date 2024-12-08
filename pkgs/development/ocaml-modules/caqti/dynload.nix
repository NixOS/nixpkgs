{ buildDunePackage, caqti, findlib }:

buildDunePackage {
  pname = "caqti-dynload";
  inherit (caqti) version src;

  propagatedBuildInputs = [ caqti findlib ];

  meta = caqti.meta // {
    description = "Dynamic linking of Caqti drivers using findlib.dynload";
  };
}
