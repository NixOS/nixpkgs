{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, ipython
, traitlets
, glibcLocales
, mock
, pytest
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

  checkInputs = [ pytest mock glibcLocales nose ];
  propagatedBuildInputs = [ ipython traitlets ];

  patches = [ ./tests_respect_pythonpath.patch ];

  checkPhase = ''
    HOME=$TMPDIR LC_ALL=en_US.utf8 py.test
  '';

  meta = with lib; {
    description = "Jupyter core package. A base package on which Jupyter projects rely";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
