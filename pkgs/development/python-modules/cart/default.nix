{
  lib,
  pycryptodome,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cart";
  version = "1.2.3";
  format = "setuptools";

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

  meta = {
    description = "Python module for the CaRT Neutering format";
    mainProgram = "cart";
    homepage = "https://github.com/CybercentreCanada/cart";
    changelog = "https://github.com/CybercentreCanada/cart/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
