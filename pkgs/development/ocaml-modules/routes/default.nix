{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "routes";
  version = "2.0.0";

  duneVersion = "3";
  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/anuragsoni/routes/releases/download/${version}/routes-${version}.tbz";
    hash = "sha256-O2KdaYwrAOUEwTtM14NUgGNxnc8BWAycP1EEuB6w1og=";
  };

  meta = {
    description = "Typed routing for OCaml applications";
    license = lib.licenses.bsd3;
    homepage = "https://anuragsoni.github.io/routes";
    maintainers = with lib.maintainers; [
      ulrikstrid
      anmonteiro
    ];
  };
}
