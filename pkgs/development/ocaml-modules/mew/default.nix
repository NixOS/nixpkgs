{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  result,
  trie,
}:

buildDunePackage (finalAttrs: {
  pname = "mew";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kandu";
    repo = "mew";
    tag = finalAttrs.version;
    hash = "sha256-QkVbjJLfjsdORKE50TP1lWThviWzEVxUH1skCZ/uJxA=";
  };

  propagatedBuildInputs = [
    result
    trie
  ];

  meta = {
    homepage = "https://github.com/kandu/mew";
    license = lib.licenses.mit;
    description = "Modal Editing Witch";
    maintainers = [ lib.maintainers.vbgl ];
  };

})
