{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  mypy,
  pytestCheckHook,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "3.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "charset_normalizer";
    tag = version;
    hash = "sha256-ZEHxBErjjvofqe3rkkgiEuEJcoluwo+2nZrLfrsHn5Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ]
  ++ lib.optional (!isPyPy) mypy;

  env.CHARSET_NORMALIZER_USE_MYPYC = lib.optionalString (!isPyPy) "1";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "charset_normalizer" ];

  passthru.tests = {
    inherit aiohttp requests;
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python module for encoding and language detection";
    mainProgram = "normalizer";
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/jawah/charset_normalizer/blob/${src.tag}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
