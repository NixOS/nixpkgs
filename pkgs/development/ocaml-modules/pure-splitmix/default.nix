{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "pure-splitmix";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Lysxia";
    repo = pname;
    rev = version;
    sha256 = "RUnsAB4hMV87ItCyGhc47bHGY1iOwVv9kco2HxnzqbU=";
  };

  doCheck = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Lysxia/pure-splitmix";
    description = "Purely functional splittable PRNG";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
=======
  meta = with lib; {
    homepage = "https://github.com/Lysxia/pure-splitmix";
    description = "Purely functional splittable PRNG";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
