{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "trie";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kandu";
    repo = "trie";
    tag = finalAttrs.version;
    hash = "sha256-j7xp1svMeYIm+WScVe/B7w0jNjMtvkp9a1hLLLlO92g=";
  };

  meta = {
    homepage = "https://github.com/kandu/trie/";
=======
buildDunePackage rec {
  pname = "trie";
  version = "1.0.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "kandu";
    repo = pname;
    rev = version;
    sha256 = "0s7p9swjqjsqddylmgid6cv263ggq7pmb734z4k84yfcrgb6kg4g";
  };

  meta = {
    inherit (src.meta) homepage;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    description = "Strict impure trie tree";
    maintainers = [ lib.maintainers.vbgl ];
  };

<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
