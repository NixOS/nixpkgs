{
  lib,
  buildPythonPackage,
  fetchurl,
  numpy,
  pythonOlder,
  uv-build,
}:

buildPythonPackage rec {
  pname = "embspec";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchurl {
    url = "https://github.com/MukundaKatta/embspec/releases/download/v${version}/embspec-${version}.tar.gz";
    hash = "sha256-8D2PBdnMTn21CDgKokU86gNKL21ZcN/Mq8NDwJ+sXqU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.7,<0.12.0" uv_build
  '';

  build-system = [ uv-build ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "embspec" ];

  doCheck = false;

  meta = {
    description = "Embedding pipeline ops and drift detection for production RAG";
    longDescription = ''
      Three primitives that close the embedding-pipeline-ops gap left between
      Evidently (tabular-ML drift heritage), Phoenix (full observability
      platform), and the Drift-Adapter paper (research code):

      * IndexManifest + embed_assert decorator: fail fast on encoder/index
        version drift.
      * DriftAdapter: linear least-squares adapter that recovers 95-99%
        retrieval after embedding-model swap without re-encoding the corpus
        (Vejendla 2025, arXiv:2509.23471).
      * neighbor_stability(): pure function comparing two retrievers on a
        frozen probe set; reports overlap, Jaccard, regressions, and a
        deploy-safety verdict.
    '';
    homepage = "https://github.com/MukundaKatta/embspec";
    changelog = "https://github.com/MukundaKatta/embspec/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mukundakatta ];
  };
}
