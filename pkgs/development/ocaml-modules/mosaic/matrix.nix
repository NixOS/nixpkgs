{
  buildDunePackage,
  mosaic,
  ppx_windtrap,
  thumper,
  windtrap,
}:

buildDunePackage {
  pname = "matrix";
  inherit (mosaic) version src;

  minimalOCamlVersion = "5.4";

  checkInputs = [
    ppx_windtrap
    thumper
    windtrap
  ];

  doCheck = true;

  meta = mosaic.meta // {
    description = "Fast, modern terminal toolkit for OCaml";
  };
}
