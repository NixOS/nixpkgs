{
  fetchFromGitHub,
  buildJanetBundle,
  lib,
}:
buildJanetBundle (finalAttrs: {
  pname = "spork";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "spork";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aAM9USwh3ZifupHVPqu/aFyaLrTGlYnzV/88RDkpLjE=";
  };

  meta = {
    description = "Various Janet utility modules - the official \"Contrib\" library.";
    homepage = "https://github.com/janet-lang/spork";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
