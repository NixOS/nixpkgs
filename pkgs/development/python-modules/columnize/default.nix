{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "columnize";
  version = "0.3.11";
  pyproject = true;

  # 3.11 is the git tag for the 0.3.11 version
  # r-ryantm keeps trying to change the version to 3.11
  # nixpkgs-update: no auto update
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
