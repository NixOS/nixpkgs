{ lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pytestCheckHook,
  torch,
  pytorch-lightning,
}:

buildPythonPackage rec {
  pname = "finetuning-scheduler";
  version = "2.3.0-rc1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "speediedan";
    repo = "finetuning-scheduler";
    rev = "refs/tags/v${version}";
    hash = "sha256-EL9VY5t81LGu9i/S/ac4DIMljY8gdeHozPyEm9uVRWw=";
  };

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    pytorch-lightning
    torch
  ];

  # needed while lightning is installed as package `pytorch-lightning` rather than`lightning`:
  env.PACKAGE_NAME = "pytorch";

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "finetuning_scheduler" ];

  meta = {
    description = "A PyTorch Lightning extension for foundation model experimentation with flexible fine-tuning schedules";
    homepage = "https://finetuning-scheduler.readthedocs.io";
    changelog = "https://github.com/speediedan/finetuning-scheduler/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
