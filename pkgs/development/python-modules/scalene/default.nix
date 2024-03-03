{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, cloudpickle
, cython
, jinja2
, psutil
, pynvml
, pythonOlder
, rich
}:

buildPythonPackage rec {
  pname = "scalene";
  version = "1.5.38";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LR1evkn2m6FNBmJnUUJubesxIPeHG6RDgLFBHDuxe38=";
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
