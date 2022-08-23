{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, fetchpatch
, python
, ipython
, traitlets
, glibcLocales
, mock
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "jupyter_core";
  version = "4.9.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1puuuf+xKLjNJlf88nA/icdp0Wc8hRgSEZ46Kg6TrZo=";
  };

  checkInputs = [ pytestCheckHook mock glibcLocales nose ];
  propagatedBuildInputs = [ ipython traitlets ];

  patches = [
    # install jupyter_core/*.py files
    (fetchpatch {
      url = "https://github.com/jupyter/jupyter_core/pull/253/commits/3bbeaebec0a53520523162d5e8d5c6ca02b1b782.patch";
      sha256 = "sha256-QeAfj7wLz4egVUPMAgrZ9Wn/Tv60LrIXLgHGVoH41wQ=";
    })
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
