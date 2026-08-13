{
  lib,
  buildDunePackage,
  fetchpatch,
  ocaml,
  bitstring,
  ppxlib,
  ounit,
}:

buildDunePackage {
  pname = "ppx_bitstring";
  inherit (bitstring) version src;

  patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
    url = "https://github.com/xguerin/bitstring/commit/b42d4924cbb5ec5fd5309e6807852b63f456f35d.patch";
    hash = "sha256-wtpSnGOzIUTmB3LhyHGopecy7F/5SYFOwaR6eReV+6g=";
  });

  buildInputs = [
    bitstring
    ppxlib
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit ];

  meta = bitstring.meta // {
    description = "Bitstrings and bitstring matching for OCaml - PPX extension";
    broken = lib.versionOlder ppxlib.version "0.18.0";
  };
}
