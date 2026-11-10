{
  lib,
  buildDunePackage,
  dune-site,
  fetchFromGitLab,
  frama-c,
  withDeduce ? true,
  swi-prolog,
}:

buildDunePackage (finalAttrs: {
  pname = "frama-c-metacsl";
  version = "0.11";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "git.frama-c.com";
    owner = "pub";
    repo = "meta";
    rev = finalAttrs.version;
    hash = "sha256-jMvuBCXZMj2eA+ZQhRJgLMjGD7AXMMEvJU7FsOMfGMk=";
  };

  propagatedBuildInputs = [
    dune-site
    frama-c
  ]
  ++ lib.optional withDeduce swi-prolog;

  postPatch =
    if withDeduce then
      ''
        patchShebangs --host deduce/run.pl
      ''
    else
      ''
        sed -i 's/(deduce[^)]*)//' dune
      '';

  meta = {
    description = "Frama-C plugin for verification of high-level ACSL requirements";
    homepage = "https://frama-c.com/fc-plugins/metacsl.html";
    license =
      with lib.licenses;
      if withDeduce then
        AND [
          lgpl21Only
          gpl3Only
        ]
      else
        lgpl21Only;
    maintainers = with lib.maintainers; [ luc65r ];
  };
})
