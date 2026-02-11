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
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "3.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "charset_normalizer";
    tag = version;
    hash = "sha256-MtSBKG8bXUsgEPyXxMRBPPFI8mfuIETy6UVshe7yqGg=";
  };

  build-system = [
    setuptools
  ]
  ++ lib.optional (!isPyPy) mypy;

  env.CHARSET_NORMALIZER_USE_MYPYC = lib.optionalString (!isPyPy) "1";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "charset_normalizer" ];

  passthru.tests = {
    inherit aiohttp requests;
  };

  meta = {
    description = "Python module for encoding and language detection";
    mainProgram = "normalizer";
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/jawah/charset_normalizer/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
