{
  lib,
  pycryptodome,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cart";
  version = "1.2.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CybercentreCanada";
    repo = "cart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oeWeay1Pr9T4oR3XSrwv9hRr/sLTel1Bt6BG6jHXxIA=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodome ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "unittests" ];

  pythonImportsCheck = [ "cart" ];

  meta = {
    description = "Python module for the CaRT Neutering format";
    mainProgram = "cart";
    homepage = "https://github.com/CybercentreCanada/cart";
    changelog = "https://github.com/CybercentreCanada/cart/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
