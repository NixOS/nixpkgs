{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.07";
  duneVersion = "3";
  pname = "eqaf";
  version = "0.9";

  src = fetchurl {
    url = "https://github.com/mirage/eqaf/releases/download/v${version}/eqaf-${version}.tbz";
    hash = "sha256-7A4oqUasaBf5XVhU8FqZYa46hAi7YQ55z60BubJV3+A=";
  };

  propagatedBuildInputs = [ cstruct ];

  meta = {
    description = "Constant time equal function to avoid timing attacks in OCaml";
    homepage = "https://github.com/mirage/eqaf";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
