{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct,
}:

buildDunePackage rec {
  pname = "hex";
  version = "1.5.0";

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/hex-${version}.tbz";
    hash = "sha256-LmfuyhsDBJMHowgxtc1pS8stPn8qa0+1l/vbZHNRtNw=";
  };

  propagatedBuildInputs = [ cstruct ];
  doCheck = true;

  meta = {
    description = "Mininal OCaml library providing hexadecimal converters";
    homepage = "https://github.com/mirage/ocaml-hex";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
