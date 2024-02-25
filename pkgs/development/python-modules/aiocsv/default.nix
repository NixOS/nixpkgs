{ lib
, aiofiles
, buildPythonPackage
, cython
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aiocsv";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MKuranowski";
    repo = "aiocsv";
    rev = "refs/tags/v${version}";
    hash = "sha256-5jMmT7XY+1VNbDNciZS6B/oQJFj4XmGvhDITKWHCuOQ=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  nativeCheckInputs = [
    aiofiles
    pytest-asyncio
    pytestCheckHook
  ];

  preBuild = ''
    export CYTHONIZE=1
  '';

  pythonImportsCheck = [
    "aiocsv"
  ];

  disabledTestPaths = [
    # Import issue
    "tests/test_parser.py"
  ];

  meta = with lib; {
    description = "Library for for asynchronous CSV reading/writing";
    homepage = "https://github.com/MKuranowski/aiocsv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
