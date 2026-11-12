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

let
  version = "1.4.0";
in
buildPythonPackage {
  pname = "motmetrics";
  version = "${version}-unstable-2026-07-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cheind";
    repo = "py-motmetrics";
    # Latest release (1.4.0) is not compatible with pandas >= 2.0
    rev = "e5ae766fab03b804f485d7c95ee1809b94d32dcc";
    hash = "sha256-B3uJ7q5r8eb17hHHVe81pKFI+RTwJ7rn5BT11sm20t0=";
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

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "motmetrics" ];

  meta = {
    description = "Benchmark multiple object trackers (MOT) in Python";
    homepage = "https://github.com/cheind/py-motmetrics";
    changelog = "https://github.com/cheind/py-motmetrics/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
