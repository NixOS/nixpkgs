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
  version = "1.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CybercentreCanada";
    repo = "cart";
    tag = "v${version}";
    hash = "sha256-oeWeay1Pr9T4oR3XSrwv9hRr/sLTel1Bt6BG6jHXxIA=";
  };

  propagatedBuildInputs = [ pycryptodome ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "unittests" ];

  pythonImportsCheck = [ "cart" ];

  meta = with lib; {
    description = "Python module for the CaRT Neutering format";
    mainProgram = "cart";
    homepage = "https://github.com/CybercentreCanada/cart";
    changelog = "https://github.com/CybercentreCanada/cart/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
