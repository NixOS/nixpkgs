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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "python-discovery";
    tag = finalAttrs.version;
    hash = "sha256-PCqE/WwhH+kzWw6Q4L/ZBwgDqHI1G1P8KsMMANO4BIQ=";
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
