{ lib }:

{
  version = "0.7.0-rc11";
  src = builtins.fetchGit {
    url = "https://gitlab.math.univ-paris-diderot.fr/cduce/cduce.git";
    rev = "bcbb652879090fe0a0531491d8048296a343cbcf";
  };
  meta = {
      homepage = "https://www.cduce.org";
      license = lib.licenses.mit;
  };
}
