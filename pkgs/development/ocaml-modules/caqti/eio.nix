{
  buildDunePackage,
  caqti,
  logs,
  eio,
}:

buildDunePackage {
  pname = "caqti-eio";
  inherit (caqti) version src;

  minimalOCamlVersion = "5.1";

  propagatedBuildInputs = [
    caqti
    logs
    eio
  ];

  meta = caqti.meta // {
    description = "Eio support for Caqti";
  };
}
