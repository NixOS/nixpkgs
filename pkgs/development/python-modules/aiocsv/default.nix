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

buildPythonPackage rec {
  pname = "aiocsv";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MKuranowski";
    repo = "aiocsv";
    tag = "v${version}";
    hash = "sha256-cNoUrD0UP8F2W2HiSm7dQL3nhiL/h0Hr6TDsAKWb24M=";
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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
