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

buildPythonPackage (finalAttrs: {
  pname = "charset-normalizer";
  version = "3.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "charset_normalizer";
    tag = finalAttrs.version;
    hash = "sha256-agTvOaEehTgI7JdUWWOkrKSQ0S3iiL3hkPphdiA5c4k=";
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
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/jawah/charset_normalizer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "normalizer";
  };
})
