{
  lib,
  aiohttp,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "charset-normalizer";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "charset_normalizer";
    tag = finalAttrs.version;
    hash = "sha256-eBZnTT15sAc36IxF8C0/iCVBvQGC1V9gd4PD2OP6uBI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=68,<84.1" setuptools
  '';

  build-system = [
    cython
    setuptools
  ];

  env.CHARSET_NORMALIZER_USE_CYTHON = "1";

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
