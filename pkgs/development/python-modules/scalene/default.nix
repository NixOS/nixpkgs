{ lib
, buildPythonPackage
, hypothesis
, fetchpatch
, fetchPypi
, setuptools
, setuptools-scm
, cloudpickle
, cython
, jinja2
, numpy
, psutil
, pynvml
, pytestCheckHook
, pythonOlder
, rich
}:

buildPythonPackage rec {
  pname = "scalene";
  version = "1.5.41";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-akjxv9Qot2lGntZxkxfFqz65VboL1qduykfjyEg1Ivg=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cloudpickle
    jinja2
    psutil
    pynvml
    rich
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    hypothesis
    numpy
  ];

  # remove scalene directory to prevent pytest import confusion
  preCheck = ''
    rm -rf scalene
  '';

  pythonImportsCheck = [ "scalene" ];

  meta = with lib; {
    description = "High-resolution, low-overhead CPU, GPU, and memory profiler for Python with AI-powered optimization suggestions";
    homepage = "https://github.com/plasma-umass/scalene";
    changelog = "https://github.com/plasma-umass/scalene/releases/tag/v${version}";
    mainProgram = "scalene";
    license = licenses.asl20;
    maintainers = with maintainers; [ sarahec ];
  };
}
