{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pyudev,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "monitorcontrol";
  version = "4.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "monitorcontrol";
    tag = version;
    hash = "sha256-4A7Cj2PWANZOmMSB9rH++TAf6SgyQd0OFULKa4JRu0s=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyudev ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ pname ];

  meta = {
    description = "Python monitor controls using DDC-CI";
    mainProgram = "monitorcontrol";
    homepage = "https://github.com/newAM/monitorcontrol";
    changelog = "https://github.com/newAM/monitorcontrol/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ newam ];
  };
}
