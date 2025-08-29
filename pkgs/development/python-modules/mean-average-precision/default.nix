{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "mean-average-precision";
  version = "2024.01.05.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bes-dev";
    repo = "mean_average_precision";
    tag = version;
    hash = "sha256-qo160L+oJsHERVOV0qdiRIZPMjvSlUmMTrAzThfrQSs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pandas
  ];

  pythonImportsCheck = [
    "mean_average_precision"
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Mean Average Precision for Object Detection";
    homepage = "https://github.com/bes-dev/mean_average_precision";
    changelog = "https://github.com/bes-dev/mean_average_precision/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
