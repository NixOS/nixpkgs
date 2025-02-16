{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.06";
  pname = "owee";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/let-def/owee/releases/download/v${version}/owee-${version}.tbz";
    hash = "sha256-YsTRsm12iy52LfM3MF90mf9cy4JoGWelqxJlI/vPs9A=";
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
