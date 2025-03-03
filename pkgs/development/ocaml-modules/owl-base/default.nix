{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "owl-base";
  version = "1.2";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/owlbarn/owl/releases/download/${version}/owl-${version}.tbz";
    hash = "sha256-OBei5DkZIsiiIltOM8qV2mgJJGmU5r8pGjAMgtjKxsU=";
  };

  minimalOCamlVersion = "4.10";

  meta = with lib; {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    changelog = "https://github.com/owlbarn/owl/releases";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
