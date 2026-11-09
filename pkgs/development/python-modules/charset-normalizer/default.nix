{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  ast-serialize,
  mypy,
  pytestCheckHook,
  requests,
  setuptools,
  withMypyc ? !isPyPy && !stdenv.hostPlatform.isStatic,
}:

buildPythonPackage (finalAttrs: {
  pname = "charset-normalizer";
  version = "3.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "charset_normalizer";
    tag = finalAttrs.version;
    hash = "sha256-zIN1y9HVwaCqixjRFLn6g/tz95E41m7t7j4eY5jNZMs=";
  };

  build-system = [
    setuptools
  ]
  ++ lib.optionals withMypyc [
    ast-serialize
    mypy
  ];

  env.CHARSET_NORMALIZER_USE_MYPYC = lib.optionalString withMypyc "1";

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
