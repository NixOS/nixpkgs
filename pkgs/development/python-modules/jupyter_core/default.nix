{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, fetchpatch
, python
, ipython
, hatchling
, traitlets
, glibcLocales
, mock
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "jupyter_core";
  version = "4.11.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wpCbm8fcp1VgpsWueMNP0wXt4xzYZNo8DQuy7Ymqkzc=";
  };
  format = "pyproject";

  buildInputs = [ hatchling ];

  checkInputs = [ pytestCheckHook mock glibcLocales nose ];
  propagatedBuildInputs = [ ipython traitlets ];

  patches = [
    ./tests_respect_pythonpath.patch
  ];

  preCheck = ''
    export HOME=$TMPDIR
    export LC_ALL=en_US.utf8
  '';

  disabledTests = [
    # creates a temporary script, which isn't aware of PYTHONPATH
    "test_argv0"
  ];

  postCheck = ''
    $out/bin/jupyter --help > /dev/null
  '';

  pythonImportsCheck = [ "jupyter_core" ];

  meta = with lib; {
    description = "Jupyter core package. A base package on which Jupyter projects rely";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
