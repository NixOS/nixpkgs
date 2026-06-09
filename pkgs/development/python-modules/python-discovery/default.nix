{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  filelock,
  platformdirs,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-discovery";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "python-discovery";
    tag = finalAttrs.version;
    hash = "sha256-S6C4/4+mK8xj4TIAphI9jlpdQlE90q2brxeEPU4H85g=";
  };

  build-system = [
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
  ];

  meta = {
    description = "Python interpreter discovery";
    changelog = "https://github.com/tox-dev/python-discovery/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/tox-dev/python-discovery";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
