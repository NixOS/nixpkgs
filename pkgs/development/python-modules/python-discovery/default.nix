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
  vermin,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-discovery";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "python-discovery";
    tag = finalAttrs.version;
    hash = "sha256-9CHK00PQ1x5L1OntVTSCmq08zFIR9FhHwEI+3jUobL4=";
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
