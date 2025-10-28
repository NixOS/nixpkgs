{
  lib,
  buildPythonPackage,
  poetry-core,
  fetchFromGitHub,
  pytestCheckHook,
  doubles,
  msgspec,
  numpy,
  pandas,
  pydantic,
  scikit-learn,
  scipy,
  toolz,
}:

buildPythonPackage rec {
  pname = "saiph";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "octopize";
    repo = "saiph";
    tag = "saiph-v${version}";
    hash = "sha256-8AbV3kjPxjZo28CgahfbdNl9+ESWOfUt8YT+mWwbo5Q=";
  };

  pyproject = true;

  build-system = [
    poetry-core
  ];

  dependencies = [
    doubles
    msgspec
    numpy
    pandas
    pydantic
    scikit-learn
    scipy
    toolz
  ];

  # No need for benchmarks
  disabledTests = [
    "benchmark_test.py"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [
    "saiph"
  ];

  meta = {
    description = "Package enabling to project data";
    homepage = "https://github.com/octopize/saiph";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
