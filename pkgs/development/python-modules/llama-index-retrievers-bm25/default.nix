{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,
  # Build system
  hatchling,
  # Dependencies
  bm25s,
  llama-index-core,
  pystemmer,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-retrievers-bm25";
  version = "0.7.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "llama_index_retrievers_bm25";
    inherit (finalAttrs) version;
    hash = "sha256-Zb/5XFwTVIVDlCCUBtLTQv9eYpg/8oGP0rhdW+1wvtA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bm25s
    llama-index-core
    pystemmer
  ];
  pythonRelaxDeps = [
    "pystemmer"
  ];

  pythonImportsCheck = [
    "llama_index.retrievers.bm25"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Llama-index retrievers bm25 integration";
    homepage = "https://pypi.org/project/llama-index-retrievers-bm25";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
