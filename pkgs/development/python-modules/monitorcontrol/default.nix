{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyudev,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "monitorcontrol";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "monitorcontrol";
    tag = version;
    hash = "sha256-KyVLNZLpzmxABQQiHGniCcND7DwZwpT4gJC+sJihoag=";
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
