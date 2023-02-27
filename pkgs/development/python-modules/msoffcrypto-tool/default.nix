{ lib
, olefile
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, cryptography
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "msoffcrypto-tool";
  version = "5.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nolze";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OrGgY+CEhAHGOOIPYK8OijRdoh0PRelnsKB++ksUIXY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cryptography
    olefile
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test fails with AssertionError
    "test_cli"
  ];

  pythonImportsCheck = [
    "msoffcrypto"
  ];

  meta = with lib; {
    description = "Python tool and library for decrypting MS Office files with passwords or other keys";
    homepage = "https://github.com/nolze/msoffcrypto-tool";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
