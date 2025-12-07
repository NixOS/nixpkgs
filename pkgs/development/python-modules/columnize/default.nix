{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "columnize";
  version = "3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "pycolumnize";
    tag = "3.11";
    hash = "sha256-YJEIujoRpLvUM4H4CB1nEJaYStFOSVKIGzchnptlt7M=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "columnize" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python module to align a simple (not nested) list in columns";
    homepage = "https://github.com/rocky/pycolumnize";
    changelog = "https://github.com/rocky/pycolumnize/blob/${src.tag}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
