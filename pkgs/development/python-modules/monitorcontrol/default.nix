{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyudev,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "monitorcontrol";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "monitorcontrol";
    tag = finalAttrs.version;
    hash = "sha256-KyVLNZLpzmxABQQiHGniCcND7DwZwpT4gJC+sJihoag=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyudev ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ finalAttrs.pname ];

  meta = {
    description = "Python monitor controls using DDC-CI";
    mainProgram = "monitorcontrol";
    homepage = "https://github.com/newAM/monitorcontrol";
    changelog = "https://github.com/newAM/monitorcontrol/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ newam ];
  };
})
