{
  buildDunePackage,
  caqti,
  logs,
  miou,
}:

buildDunePackage {
  pname = "caqti-miou";
  inherit (caqti) version src;

  minimalOCamlVersion = "5.1";

  propagatedBuildInputs = [
    caqti
    logs
    miou
  ];

  meta = caqti.meta // {
    description = "Miou support for Caqti";
  };
}
