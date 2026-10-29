{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  extlib,
  ocaml-sat-solvers,
  tcs-lib,
}:

buildDunePackage (finalAttrs: {
  pname = "pgsolver";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "tcsprojects";
    repo = "pgsolver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VQWXvZXfGHCfzz46aARyFXO/xlJ/7s39HFIfisEamXw=";
  };

  # upstream missing `public_names` within `executables` stanza
  # adding this back to automatically install binaries
  patchPhase = ''
    runHook prePatch
    sed -i '/^ (names /{ p; s/names/public_names/ }' src/apps/pgsolver/dune
    sed -i '/^ (names /{ p; s/names/public_names/ }' src/apps/tools/dune
    runHook postPatch
  '';

  propagatedBuildInputs = [
    extlib
    ocaml-sat-solvers
    tcs-lib
  ];

  meta = {
    description = "Collection of tools for generating, manipulating and - most of all - solving parity games";
    homepage = "https://github.com/tcsprojects/pgsolver";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
    mainProgram = "pgsolver";
  };
})
