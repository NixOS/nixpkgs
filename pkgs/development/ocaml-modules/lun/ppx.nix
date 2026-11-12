{
  lib,
  buildDunePackage,
  fmt,
  lun,
  ppxlib,
}:

buildDunePackage {
  pname = "ppx_lun";
  inherit (lun) version src;

  minimalOCamlVersion = "5.3";

  propagatedBuildInputs = [
    lun
    ppxlib
  ];

  checkInputs = [ fmt ];

  doCheck = true;

  meta = lun.meta // {
    description = "Optics with lun package and PPX";
    license = lib.licenses.mit;
  };
}
