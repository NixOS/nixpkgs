{
  lib,
  buildPythonPackage,
  cython,
  gcc,
  setuptools,
  fetchFromGitHub,
  mock,
  numpy,
  scipy,
  smart-open,
  pyemd,
  pytestCheckHook,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piskvorky";
    repo = "gensim";
    tag = "${version}";
    hash = "sha256-TXutcU43ReBj9ss9+zBJFUxb5JqVHpl+B0c7hqcJAJY=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    smart-open
    numpy
    scipy
  ];

  nativeCheckInputs = [
    mock
    pyemd
    pytestCheckHook
    testfixtures
  ];

  # Build Cython extensions, required during checkPhase
  preBuild = ''
    python setup.py build_ext --inplace
  '';

  nativeBuildInputs = [
    cython
    gcc
  ];

  pythonImportsCheck = [ "gensim" ];

  enabledTestPaths = [ "gensim/test" ];

  # test_parallel is flaky under load
  disabledTests = [ "test_parallel" ];

  preCheck = ''
    export GENSIM_DATA_DIR="$NIX_BUILD_TOP/gensim-data"
    mkdir -p "$GENSIM_DATA_DIR"
    export SKIP_NETWORK_TESTS=1
  '';

  meta = with lib; {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
  };
}
