{
  lib,
  buildPythonPackage,
  hypothesis,
  fetchPypi,
  setuptools,
  setuptools-scm,
  cloudpickle,
  cython,
  jinja2,
  numpy,
  psutil,
  pynvml,
  pytestCheckHook,
  pythonOlder,
  rich,
}:

buildPythonPackage rec {
  pname = "scalene";
  version = "1.5.42.2";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0ZGk0xFBFSeeg4vjNXu/ppGdEKGhUc2ql4R6oWG23aQ=";
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

  nativeCheckInputs = [ pytestCheckHook ];

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
