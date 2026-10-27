{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

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
    license = lib.licenses.mit;
    description = "Strict impure trie tree";
    maintainers = [ lib.maintainers.vbgl ];
  };

})
