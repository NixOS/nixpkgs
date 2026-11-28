{
  buildDunePackage,
  mosaic,
  ppx_windtrap,
  thumper,
  windtrap,
}:

buildDunePackage {
  pname = "toffee";
  inherit (mosaic) version src;

  minimalOCamlVersion = "5.1";

  checkInputs = [
    ppx_windtrap
    windtrap
    thumper
  ];

  doCheck = true;

  meta = mosaic.meta // {
    description = "CSS layout engine for OCaml (Flexbox, Grid, Block)";
  };
}
