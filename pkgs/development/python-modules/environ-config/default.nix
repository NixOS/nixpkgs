{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  attrs,
  importlib-metadata,
  pytestCheckHook,
  moto,
}:
buildPythonPackage rec {
  pname = "environ-config";
  version = "26.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "environ-config";
    owner = "hynek";
    tag = version;
    hash = "sha256-baj61mS4rSLMngrAdmSwupN/2ewo/GDwbZqFTr8fVuE=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    attrs
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    moto
  ];

  pythonImportsCheck = [ "environ" ];

  meta = {
    description = "Python Application Configuration With Environment Variables";
    homepage = "https://github.com/hynek/environ-config";
    changelog = "https://github.com/hynek/environ-config/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
