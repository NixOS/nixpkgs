{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
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
=======
  cython_0,
  oldest-supported-numpy,
  setuptools,
  fetchPypi,
  mock,
  numpy,
  scipy,
  smart-open,
  pyemd,
  pytestCheckHook,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "gensim";
<<<<<<< HEAD
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piskvorky";
    repo = "gensim";
    tag = version;
    hash = "sha256-TXutcU43ReBj9ss9+zBJFUxb5JqVHpl+B0c7hqcJAJY=";
  };

  build-system = [
    cython
=======
  version = "4.3.3";
  pyproject = true;

  # C code generated with CPython3.12 does not work cython_0.
  disabled = !(pythonOlder "3.12");

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hIUgdqaj2I19rFviReJMIcO4GbVl4UwbYfo+Xudtz1c=";
  };

  build-system = [
    cython_0
    oldest-supported-numpy
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    setuptools
  ];

  dependencies = [
<<<<<<< HEAD
    numpy
    scipy
    smart-open
=======
    smart-open
    numpy
    scipy
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  nativeCheckInputs = [
    mock
    pyemd
    pytestCheckHook
<<<<<<< HEAD
    testfixtures
=======
  ];

  pythonRelaxDeps = [
    "scipy"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "gensim" ];

<<<<<<< HEAD
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
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${version}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
=======
  # Test setup takes several minutes
  doCheck = false;

  enabledTestPaths = [ "gensim/test" ];

  meta = with lib; {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
