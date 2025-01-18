{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.07";
  pname = "eqaf";
  version = "0.10";

  src = fetchurl {
    url = "https://github.com/mirage/eqaf/releases/download/v${version}/eqaf-${version}.tbz";
    hash = "sha256-Z9E2nFfE0tFKENAmMtReNVIkq+uYrsCJecC65YQwku4=";
  };

  meta = with lib; {
    description = "Constant time equal function to avoid timing attacks in OCaml";
    homepage = "https://github.com/mirage/eqaf";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };

}
