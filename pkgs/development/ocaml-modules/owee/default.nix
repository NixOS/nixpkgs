{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  minimalOCamlVersion = "4.06";
  useDune2 = true;
  pname = "owee";
  version = "0.4";

  src = fetchurl {
    url = "https://github.com/let-def/owee/releases/download/v${version}/owee-${version}.tbz";
    sha256 = "sha256:055bi0yfdki1pqagbhrwmfvigyawjgsmqw04zhpp6hds8513qzvb";
  };

  meta = {
    description = "An experimental OCaml library to work with DWARF format";
    homepage = "https://github.com/let-def/owee/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
