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
  version = "1.5.38";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LR1evkn2m6FNBmJnUUJubesxIPeHG6RDgLFBHDuxe38=";
  };

  patches = [
    # fix scalene_config import. remove on next update
    (fetchpatch {
      name = "scalene_config-import-fix.patch";
      url = "https://github.com/plasma-umass/scalene/commit/cd437be11f600ac0925ce77efa516e6d83934200.patch";
      hash = "sha256-YjFh+mu5jyIJYUQFhmGqLXhec6lgQAdj4tWxij3NkwU=";
    })
  ];

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

  disabledTestPaths = [
    # remove on next update
    # Failing Darwin-specific tests that were subsequently removed from the source repo.
    "tests/test_coverup_35.py"
    "tests/test_coverup_42.py"
    "tests/test_coverup_43.py"
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
