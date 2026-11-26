{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,

  # dependencies
  filelock,
  platformdirs,

  # tests
  pytest-mock,
  pytestCheckHook,
  vermin,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-discovery";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "python-discovery";
    tag = finalAttrs.version;
    hash = "sha256-pbBtcNLlBBc5DoseD1sMkNfvNjFy/rvihPfOp1xceXg=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    filelock
    platformdirs
  ];

  pythonImportsCheck = [ "python_discovery" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    vermin
  ];

  meta = {
    description = "Python interpreter discovery";
    changelog = "https://github.com/tox-dev/python-discovery/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/tox-dev/python-discovery";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
