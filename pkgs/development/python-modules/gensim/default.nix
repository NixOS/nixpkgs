{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  numpy,
  scipy,
  smart-open,

  # tests
  mock,
  pyemd,
  pytestCheckHook,
  testfixtures,
}:

buildPythonPackage (finalAttrs: {
  pname = "gensim";
  version = "4.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "piskvorky";
    repo = "gensim";
    tag = finalAttrs.version;
    hash = "sha256-TXutcU43ReBj9ss9+zBJFUxb5JqVHpl+B0c7hqcJAJY=";
  };

  patches = [
    # Fall back to serial chunkize when the multiprocessing start method is not
    # "fork" (the default changed to "forkserver" on Linux with Python 3.14).
    # Vendored (filtered to gensim/utils.py) from the not yet merged
    # https://github.com/piskvorky/gensim/pull/3649
    ./python314-chunkize-forkserver.patch
  ];

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    smart-open
  ];

  nativeCheckInputs = [
    mock
    pyemd
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [ "gensim" ];

  enabledTestPaths = [ "gensim/test" ];

  # test_parallel is flaky under load
  disabledTests = [ "test_parallel" ];

  preCheck = ''
    export GENSIM_DATA_DIR="$NIX_BUILD_TOP/gensim-data"
    mkdir -p "$GENSIM_DATA_DIR"
    export SKIP_NETWORK_TESTS=1
  ''
  # Prevent python from importing gensim from the source files during tests
  + ''
    rm gensim/__init__.py
  '';

  meta = {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    downloadPage = "https://github.com/piskvorky/gensim";
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
  };
})
