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

<<<<<<< HEAD
  meta = {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    changelog = "https://github.com/owlbarn/owl/releases";
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = [ lib.maintainers.bcdarwin ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    changelog = "https://github.com/owlbarn/owl/releases";
    platforms = platforms.x86_64 ++ platforms.aarch64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
