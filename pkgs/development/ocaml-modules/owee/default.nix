{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";
  pname = "owee";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/let-def/owee/releases/download/v${version}/owee-${version}.tbz";
    hash = "sha256-Bk9iRfWZXV0vTx+cbSmS4v2+Pd4ygha67Hz6vUhXlA0=";
  };

  meta = with lib; {
    description = "Experimental OCaml library to work with DWARF format";
    homepage = "https://github.com/let-def/owee/";
    license = licenses.mit;
    maintainers = with maintainers; [
      vbgl
      alizter
    ];
  };
}
