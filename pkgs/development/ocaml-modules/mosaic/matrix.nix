{
  buildDunePackage,
  mosaic,
  windtrap,
  ppx_windtrap,
}:

buildDunePackage {
  pname = "matrix";
  inherit (mosaic) version src;

  minimalOCamlVersion = "5.4";

  checkInputs = [
    windtrap
    ppx_windtrap
  ];

  doCheck = true;

  meta = mosaic.meta // {
    description = "Fast, modern terminal toolkit for OCaml";
  };
}
