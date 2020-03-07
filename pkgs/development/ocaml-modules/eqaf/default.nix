{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  pname = "eqaf";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/mirage/eqaf/releases/download/v${version}/eqaf-v${version}.tbz";
    sha256 = "1wkkmw8q2ml7ifpg0g06y0sclq0zvjf6dpsi36dnci7f230q3vsq";
  };

  meta = {
    description = "Constant time equal function to avoid timing attacks in OCaml";
    homepage = "https://github.com/mirage/eqaf";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
