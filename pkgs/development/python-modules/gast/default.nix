{
  lib,
  astunparse,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gast";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "gast";
    rev = "refs/tags/${version}";
    hash = "sha256-zrbxW8qWhCY6tObP+/WDReoCnlCpMEzQucX2inpRTL4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    astunparse
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gast" ];

  meta = {
    description = "Compatibility layer between the AST of various Python versions";
    homepage = "https://github.com/serge-sans-paille/gast/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      jyp
      cpcloud
    ];
  };
}
