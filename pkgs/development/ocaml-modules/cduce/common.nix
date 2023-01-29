{ lib, fetchgit }:

{
  version = "0.7.0-rc11";
  src = fetchgit {
    url = "https://gitlab.math.univ-paris-diderot.fr/cduce/cduce.git";
    rev = "bcbb652879090fe0a0531491d8048296a343cbcf";
    hash = "sha256-Ad5wVh/CWS+jxzVvDG4p3F8psxAI9Ac0UFB3C4vWgLI=";
  };
  meta = {
    homepage = "https://www.cduce.org";
    license = lib.licenses.mit;
  };
}
