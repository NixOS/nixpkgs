{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "chess";
  version = "1.11.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-8LOp4HQI9UOdaj4/jwd79ftdnaO4HtzMVf1cwcYFCiA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "chess" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  meta = with lib; {
    description = "Chess library with move generation, move validation, and support for common formats";
    homepage = "https://github.com/niklasf/python-chess";
    changelog = "https://github.com/niklasf/python-chess/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ smancill ];
  };
}
