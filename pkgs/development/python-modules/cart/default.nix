{
  lib,
  pycryptodome,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cart";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CybercentreCanada";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0dHdXb4v92681xL21FsrIkNgNQ9R5ULV1lnSCITZzP8=";
  };

  propagatedBuildInputs = [ pycryptodome ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "unittests" ];

  pythonImportsCheck = [ "cart" ];

  meta = with lib; {
    description = "Python module for the CaRT Neutering format";
    mainProgram = "cart";
    homepage = "https://github.com/CybercentreCanada/cart";
    changelog = "https://github.com/CybercentreCanada/cart/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
