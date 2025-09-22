{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
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
    mypy
    setuptools
    setuptools-scm
  ];

  env.CHARSET_NORMALIZER_USE_MYPYC = "1";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "charset_normalizer" ];

  passthru.tests = {
    inherit aiohttp requests;
  };

  meta = with lib; {
    description = "Python module for encoding and language detection";
    mainProgram = "normalizer";
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/jawah/charset_normalizer/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
