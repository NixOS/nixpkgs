{
  lib,
  buildDunePackage,
  bitstring,
  ppxlib,
  ounit,
}:

buildDunePackage {
  pname = "ppx_bitstring";
  inherit (bitstring) version src;

  buildInputs = [
    bitstring
    ppxlib
  ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = bitstring.meta // {
    description = "Bitstrings and bitstring matching for OCaml - PPX extension";
  };
}
