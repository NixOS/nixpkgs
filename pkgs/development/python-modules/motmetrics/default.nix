{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  pandas,
  scipy,
  xmltodict,

  # tests
  pytestCheckHook,
  pytest-benchmark,
}:

buildPythonPackage {
  pname = "motmetrics";
  version = "1.4.0-unstable-2025-01-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cheind";
    repo = "py-motmetrics";
    # Latest release is not compatible with pandas 2.0
    rev = "c199b3e853d589af4b6a7d88f5bcc8b8802fc434";
    hash = "sha256-DJ82nioW3jdIVo1B623BE8bBhVa1oMzYIkhhit4Z4dg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    scipy
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "motmetrics" ];

  meta = with lib; {
    description = "Benchmark multiple object trackers (MOT) in Python";
    homepage = "https://github.com/cheind/py-motmetrics";
    changelog = "https://github.com/cheind/py-motmetrics/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
