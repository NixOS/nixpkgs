{
  buildPythonPackage,
  fetchFromGitHub,
  hdbscan,
  lib,
  llvmlite,
  numpy,
  pandas,
  plotly,
  pytestCheckHook,
  scikit-learn,
  sentence-transformers,
  setuptools,
  tqdm,
  umap-learn,
  writableTmpDirAsHomeHook,

  # extras: datamap
  datamapplot,
  matplotlib,

  # extras: fastembed
  fastembed,

  # extras: gensim
  gensim,

  # extras: spacy
  spacy,

  # extras: vision
  accelerate,
  pillow,
}:

buildPythonPackage rec {
  pname = "bertopic";
  version = "0.17.3";
  pyproject = true;

  # pypi does not ship with all test files included
  src = fetchFromGitHub {
    owner = "MaartenGr";
    repo = "BERTopic";
    tag = "v${version}";
    hash = "sha256-wtFOe/Y0liEH23PmefRR5aYHsWmvjGZR7rKXUseFpSw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hdbscan
    umap-learn
    numpy
    pandas
    plotly
    scikit-learn
    sentence-transformers
    tqdm
    llvmlite
  ];

  optional-dependencies = {
    datamap = [
      datamapplot
      matplotlib
    ];
    fastembed = [ fastembed ];
    gensim = [ gensim ];
    spacy = [ spacy ];
    vision = [
      accelerate
      pillow
    ];
  };

  pythonImportsCheck = [ "bertopic" ];

  nativeCheckInputs = [
    # numba caches some compiled functions in the home dir
    # See https://github.com/numba/numba/issues/4032#issuecomment-488102702
    writableTmpDirAsHomeHook
    pytestCheckHook
  ];

  disabledTestPaths = [
    # network access
    "tests/test_bertopic.py"
    "tests/test_plotting/test_approximate.py"
    "tests/test_plotting/test_bar.py"
    "tests/test_plotting/test_documents.py"
    "tests/test_plotting/test_dynamic.py"
    "tests/test_plotting/test_heatmap.py"
    "tests/test_plotting/test_term_rank.py"
    "tests/test_plotting/test_topics.py"
    "tests/test_reduction/test_merge.py"
    "tests/test_representation/test_get.py"
    "tests/test_representation/test_labels.py"
    "tests/test_representation/test_representations.py"
    "tests/test_sub_models/test_dim_reduction.py"
    "tests/test_sub_models/test_embeddings.py"
    "tests/test_variations/test_class.py"
    "tests/test_variations/test_dynamic.py"
    "tests/test_variations/test_hierarchy.py"
    "tests/test_vectorizers/test_ctfidf.py"
    "tests/test_vectorizers/test_online_cv.py"
  ];

  meta = {
    changelog = "https://github.com/MaartenGr/BERTopic/releases/tag/v${version}";
    description = "Topic modeling with state-of-the-art transformer models";
    homepage = "https://maartengr.github.io/BERTopic/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hendrikheil ];
  };
}
