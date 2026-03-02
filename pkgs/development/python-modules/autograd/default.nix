{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  numpy,

  # tests
  pytest-cov,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "autograd";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HIPS";
    repo = "autograd";
    tag = "v${version}";
    hash = "sha256-k4rcalwznKS2QvmyTLra+ciWFifnILW/DDdB8D+clxQ=";
  };

  build-system = [ hatchling ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-cov
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "autograd" ];

  meta = {
    description = "Compute derivatives of NumPy code efficiently";
    homepage = "https://github.com/HIPS/autograd";
    changelog = "https://github.com/HIPS/autograd/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
