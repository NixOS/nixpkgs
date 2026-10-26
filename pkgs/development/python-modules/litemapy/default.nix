{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  nbtlib,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "litemapy";
  version = "0.11.0b0";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "SmylerMC";
    repo = "litemapy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jqJYiggAs/JA+CJ35HzpsIQA/5p8PRFkbmPlwJvTI28=";
  };

  propagatedBuildInputs = [
    nbtlib
    typing-extensions
  ];

  pythonImportsCheck = [ "litemapy" ];

  meta = {
    description = "Python library to read and edit Litematica's schematic file format";
    homepage = "https://github.com/SmylerMC/litemapy";
    changelog = "https://github.com/SmylerMC/litemapy/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      gdd
      kuflierl
    ];
  };
})
