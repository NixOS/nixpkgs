{
  buildDunePackage,
  mosaic,
  windtrap,
  ppx_windtrap,
}:

buildDunePackage {
  pname = "toffee";
  inherit (mosaic) version src;

  minimalOCamlVersion = "5.1";

  checkInputs = [
    windtrap
    ppx_windtrap
  ];

  doCheck = true;

  meta = mosaic.meta // {
    description = "CSS layout engine for OCaml (Flexbox, Grid, Block)";
  };
}
