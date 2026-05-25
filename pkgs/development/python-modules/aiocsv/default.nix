{
  lib,
  aiofiles,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiocsv";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MKuranowski";
    repo = "aiocsv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WENNtQKvpUuoYai6r8nTRamwCOloVA42YoAA3JGK9B8=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    aiofiles
    pytest-asyncio
    pytestCheckHook
  ];

  preBuild = ''
    export CYTHONIZE=1
  '';

  pythonImportsCheck = [ "aiocsv" ];

  disabledTestPaths = [
    # Import issue
    "tests/test_parser.py"
  ];

  meta = {
    description = "Library for for asynchronous CSV reading/writing";
    homepage = "https://github.com/MKuranowski/aiocsv";
    changelog = "https://github.com/MKuranowski/aiocsv/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
