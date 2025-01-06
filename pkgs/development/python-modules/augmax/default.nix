{
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  jax,
  jaxlib,
  lib,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "augmax";
  version = "0.3.3";
  pyproject = true;

  disbaled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "khdlr";
    repo = "augmax";
    rev = "refs/tags/v${version}";
    hash = "sha256-FXgkhZEAR1Y2LvVvV+IWMSQDWrLulLDsSKKuw4ER5wg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    einops
    jax
  ];

  # augmax does not have any tests at the time of writing (2022-02-19), but
  # jaxlib is necessary for the pythonImportsCheckPhase.
  nativeCheckInputs = [ jaxlib ];

  pythonImportsCheck = [ "augmax" ];

  meta = with lib; {
    description = "Efficiently Composable Data Augmentation on the GPU with Jax";
    homepage = "https://github.com/khdlr/augmax";
    changelog = "https://github.com/khdlr/augmax/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
