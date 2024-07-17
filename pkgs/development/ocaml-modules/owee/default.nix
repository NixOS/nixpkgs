{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.06";
  pname = "owee";
  version = "0.7";

  src = fetchurl {
    url = "https://github.com/let-def/owee/releases/download/v${version}/owee-${version}.tbz";
    hash = "sha256-9FXcmddHg5mk5UWgYd4kTPOLOY/p6A/OBuvfas4elUA=";
  };

  meta = with lib; {
    description = "An experimental OCaml library to work with DWARF format";
    homepage = "https://github.com/let-def/owee/";
    license = licenses.mit;
    maintainers = with maintainers; [
      vbgl
      alizter
    ];
  };
}
